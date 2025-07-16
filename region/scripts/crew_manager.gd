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
var seleted_crew: Array[CharacterBody2D] = []


func _ready() -> void:
	_spawn_crew()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		_clear_selected_crew()
	
	if event.is_action_pressed("interact"):
		var target_pos: Vector2 = get_global_mouse_position()
		for crew_member in seleted_crew:
			crew_member.target_position = target_pos


func _spawn_crew() -> void:
	for crew_member in crew_data:
		var crew_member_scene: PackedScene = crew_scenes[crew_member.character_class]
		if crew_member_scene == null:
			print_debug("No scene found for %s" % crew_member.character_class)
			continue
		var crew_member_instance: CharacterBody2D = crew_member_scene.instantiate()
		
		crew_member_instance.character_data = crew_member
		crew_member_instance.global_position = truck.global_position + Vector2(0, 25)
		crew_member_instance.connect("Crew_Selected", _crew_member_selected)

		add_child(crew_member_instance)


func _crew_member_selected(member: CharacterBody2D) -> void:
	seleted_crew.append(member)


func _clear_selected_crew() -> void:
	for crew_member in seleted_crew:
		crew_member.unselect_self()
	seleted_crew.clear()