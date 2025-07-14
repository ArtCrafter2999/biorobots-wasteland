extends Control

signal Upgrade_Selected(index: int)
signal Upgrade_Deselected

@export var resource_counter: RichTextLabel
@export var upgrades: ItemList


func _ready() -> void:
	PlayerInventory.connect("Inventory_Updated", _update_counters)
	_update_counters()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") and upgrades.is_anything_selected():
		accept_event()
		upgrades.deselect_all()
		Upgrade_Deselected.emit()

func _update_counters() -> void:
	var energy: float = PlayerInventory.get_item_amount("energy")
	var water: float = PlayerInventory.get_item_amount("water")
	var junk: float = PlayerInventory.get_item_amount("junk")
	resource_counter.text = "Energy - %s\nWater - %s\nJunk - %s" % [energy, water, junk]


func _initiate_upgrade_list(truck_upgrades: Dictionary) -> void:
	upgrades.clear()
	for upgrade in truck_upgrades.keys():
		upgrades.add_item(
			upgrade.capitalize() + " - " + str(truck_upgrades[upgrade]["cost"]) + "J",
			truck_upgrades[upgrade]["icon"]
		)


func _on_upgrade_selected(index: int) -> void:
	Upgrade_Selected.emit(index)
