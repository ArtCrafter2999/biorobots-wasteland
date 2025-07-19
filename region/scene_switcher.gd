extends Node2D
class_name SceneSwitcher

var inside_scene: String = "res://truck/interior/truck_interior.tscn" 
var outside_scene: String = "res://region/region.tscn"


func _switch_to_inside() -> void:
	get_tree().change_scene_to_file(inside_scene)


func _switch_to_outside() -> void:
	get_tree().change_scene_to_file(outside_scene)
