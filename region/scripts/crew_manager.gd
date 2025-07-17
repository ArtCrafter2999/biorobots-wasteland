extends Node2D

@export_group("Nodes")
@export var truck: Node2D
@export var ground: TileMapLayer
@export var attack_area: Area2D

@onready var crew_data: Array[CharacterData] = GameState.characters

var crew_scenes: Dictionary[StringName, PackedScene] = {
	&"guard": preload("res://character/classes/guard/guard.tscn"),
	&"medic": null,
	&"gatherer": null,
}
var selected_crew: Array[CharacterBody2D] = []
var selection_possible: bool = false


func _ready() -> void:
	GameState.characters.append(load("res://character/data/guard_steve.tres"))
	GameState.characters.append(load("res://character/data/guard_steve.tres"))
	_spawn_crew()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		_clear_selected_crew()
	
	if event.is_action_pressed("interact") and selected_crew.size() > 0 and not selection_possible:
		_move_crew_to_pos(get_global_mouse_position())


func _spawn_crew() -> void:
	for crew_member in crew_data:
		var crew_member_scene: PackedScene = crew_scenes[crew_member.character_class]
		if crew_member_scene == null:
			print_debug("No scene found for %s" % crew_member.character_class)
			continue
		var crew_member_instance: CharacterBody2D = crew_member_scene.instantiate()
		
		crew_member_instance.character_data = crew_member
		crew_member_instance.global_position = truck.global_position + Vector2(
			randf_range(-50, 50), randf_range(50, 100)
		)

		crew_member_instance.connect("Crew_Selected", _crew_member_selected)
		crew_member_instance.connect("Crew_Selection_Possible", _on_crew_selection_possible)

		add_child(crew_member_instance)


func _move_crew_to_pos(pos: Vector2) -> void:
	for crew_member in selected_crew:
		crew_member.target_position = pos + Vector2(
			randf_range(-30, 30), randf_range(-30, 30)
		)
		crew_member.send_state_event("target_pos_set")
	print_debug("Moved selected crew to pos %s" % pos)


func _crew_member_selected(member: CharacterBody2D) -> void:
	selected_crew.append(member)


func _on_crew_selection_possible(is_possible: bool) -> void:
	selection_possible = is_possible


func _clear_selected_crew() -> void:
	for crew_member in selected_crew:
		crew_member.unselect_self()
	selected_crew.clear()
	print_debug("Cleared selected crew")
