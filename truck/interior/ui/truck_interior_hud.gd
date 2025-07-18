extends Control

signal Upgrade_Selected(index: int)
signal Upgrade_Deselected
signal Next_Region

@export var resource_counter: RichTextLabel
@export var travel_cost: RichTextLabel
@export var upgrades: ItemList
@export var confirm_panel: Control


func _ready() -> void:
	PlayerInventory.connect("Inventory_Updated", _update_counters)
	_update_counters()
	confirm_panel.hide()
	show()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") and upgrades.is_anything_selected():
		accept_event()
		upgrades.deselect_all()
		Upgrade_Deselected.emit()

func _update_counters() -> void:
	var energy: int = int(PlayerInventory.get_item_amount("energy"))
	var junk: int = int(PlayerInventory.get_item_amount("junk"))
	resource_counter.text = "Energy - %s\nJunk - %s" % [energy, junk]


func _initiate_upgrade_list(truck_upgrades: Dictionary) -> void:
	upgrades.clear()
	for upgrade in truck_upgrades.keys():
		upgrades.add_item(
			upgrade.capitalize() + " - " + str(truck_upgrades[upgrade]["cost"]) + "J",
			truck_upgrades[upgrade]["icon"]
		)


func _on_upgrade_selected(index: int) -> void:
	Upgrade_Selected.emit(index)


func _on_next_region_pressed() -> void:
	confirm_panel.show()


func _player_ready() -> void:
	confirm_panel.hide()
	Next_Region.emit()
	print_debug("Next region confirmed.")


func _player_not_ready() -> void:
	confirm_panel.hide()
