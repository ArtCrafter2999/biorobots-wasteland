extends Node2D

@export_group("Nodes")
@export var truck: Node2D
@export var ground: TileMapLayer

@onready var crew_data: Array[CharacterData] = GameState.characters

var crew_scenes: Dictionary[StringName, PackedScene] = {
	&"guard": preload("res://character/classes/guard/guard.tscn"),
	&"medic": null,
	&"gatherer": null,
}
var selected_crew: Array[CharacterBody2D] = []


func _ready() -> void:
	GameState.characters.append(load("res://character/data/guard_steve.tres"))
	_spawn_crew()


func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		_clear_selected_crew()
	
	if Input.is_action_just_pressed("interact") and selected_crew.size() > 0:
		_move_crew_to_pos(get_global_mouse_position())


func _spawn_crew() -> void:
	for crew_member in crew_data:
		var crew_member_scene: PackedScene = crew_scenes[crew_member.character_class]
		if crew_member_scene == null:
			print_debug("No scene found for %s" % crew_member.character_class)
			continue
		var crew_member_instance: CharacterBody2D = crew_member_scene.instantiate()
		
		crew_member_instance.character_data = crew_member
		crew_member_instance.global_position = truck.global_position + Vector2(0, -70)
		crew_member_instance.connect("Crew_Selected", _crew_member_selected)

		add_child(crew_member_instance)


func _move_crew_to_pos(pos: Vector2) -> void:
	for crew_member in selected_crew:
		crew_member.target_position = pos
		crew_member.send_state_event("target_pos_set")


func _crew_member_selected(member: CharacterBody2D) -> void:
	selected_crew.append(member)


func _clear_selected_crew() -> void:
	for crew_member in selected_crew:
		crew_member.unselect_self()
	selected_crew.clear()
