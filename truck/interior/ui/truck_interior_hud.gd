class_name TruckInteriorHud
extends Control

signal Upgrade_Selected(index: int)
signal Upgrade_Deselected
signal Next_Region
signal Recycle_Crew_Member(member: CharacterData)
signal Button_Clicked

@export var resource_counter: RichTextLabel
@export var travel_cost: RichTextLabel
@export var upgrades: ItemList
@export var confirm_panel: Control
@export var crew_list: ItemList

@onready var not_enough_energy_panel: PanelContainer = $MarginContainer/HBoxContainer/NotEnoughEnergyPanel


func _ready() -> void:
	PlayerInventory.connect("Inventory_Updated", _update_counters)
	_update_counters()
	_update_crew_list()
	confirm_panel.hide()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") and upgrades.is_anything_selected():
		accept_event()
		upgrades.deselect_all()
		crew_list.deselect_all()
		Upgrade_Deselected.emit()


func _update_counters() -> void:
	var energy: int = int(PlayerInventory.get_item_amount("energy"))
	var junk: int = int(PlayerInventory.get_item_amount("junk"))
	resource_counter.text = "Energy - %s\nJunk - %s" % [energy, junk]


func _update_crew_list() -> void:
	crew_list.clear()
	for crew_member in GameState.characters.filter(func (ch): return ch):
		crew_list.add_item("%s (%s)" % [crew_member.name, crew_member.character_class])
		print_debug("Added %s to crew list" % crew_member.name)


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
	Button_Clicked.emit()
	confirm_panel.show()


func _player_ready() -> void:
	confirm_panel.hide()
	Button_Clicked.emit()
	Next_Region.emit()
	print_debug("Next region confirmed.")


func _player_not_ready() -> void:
	confirm_panel.hide()


func _on_recycle_crew_pressed() -> void:
	if crew_list.get_selected_items().size() == 0:
		print_debug("No crew member selected.")
		return
	
	var member: CharacterData = GameState.characters[crew_list.get_selected_items()[0]]
	GameState.characters.erase(member)
	PlayerInventory.add_item("energy", 5)
	Recycle_Crew_Member.emit(member)
	_update_crew_list()
	not_enough_energy_panel.hide()
	Button_Clicked.emit()

func show_not_enough():
	not_enough_energy_panel.show();
