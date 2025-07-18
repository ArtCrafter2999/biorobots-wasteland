extends Node2D

@export_group("Nodes")
@export var truck: Node2D
@export var ground: TileMapLayer
@export var attack_area: Area2D

var selected_crew: Array[CrewCharacter] = []
var selection_possible: bool = false


func _ready() -> void:
	GameState.characters.append(load("res://character/data/guard_steve.tres")) # REMOVE THESE BEFORE BUILD
	GameState.characters.append(load("res://character/data/guard_steve.tres"))
	_spawn_crew()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		_clear_selected_crew()
	
	if event.is_action_pressed("interact") and selected_crew.size() > 0 and not selection_possible:
		_move_crew_to_pos(get_global_mouse_position())


func _spawn_crew() -> void:
	for crew_member in GameState.get_instantiated_characters():
		crew_member.connect("Selected", _crew_member_selected)
		crew_member.connect("Selection_Possible", _on_crew_selection_possible)

		crew_member.global_position = Vector2(randf_range(-100, 100), randf_range(-50, 150))
		add_child(crew_member)

		print_debug("Spawned crew member %s (%s)" % 
		[crew_member.character_data.name, crew_member.character_data.character_class]
		)


func _move_crew_to_pos(pos: Vector2) -> void:
	for crew_member in selected_crew:
		crew_member.order(pos)


func _crew_member_selected(member: CrewCharacter) -> void:
	selected_crew.append(member)


func _on_crew_selection_possible(is_possible: bool) -> void:
	selection_possible = is_possible


func _clear_selected_crew() -> void:
	for crew_member in selected_crew:
		crew_member.unselect_self()
	selected_crew.clear()
	print_debug("Cleared selected crew")
