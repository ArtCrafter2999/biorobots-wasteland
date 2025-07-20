extends Node2D
class_name SceneSwitcher

@export var truck_interior_hud: TruckInteriorHud;

var inside_scene: String = "res://truck/interior/truck_interior.tscn" 
var outside_scene: String = "res://region/region.tscn"



func _switch_to_inside() -> void:
	get_tree().change_scene_to_file(inside_scene)


func _switch_to_outside() -> void:
	if PlayerInventory.get_item_amount("biomass") < 5 + GameState.characters.size():
		truck_interior_hud.show_not_enough();
		print_debug("Not enough biomass to switch to outside!")
		return
	GameState.day_count += 1
	PlayerInventory.remove_item("biomass", 5 + GameState.characters.size())
	if GameState.day_count % 2 == 1:
		GameState.generate_crew(1)
	get_tree().change_scene_to_file(outside_scene)
