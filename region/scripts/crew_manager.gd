extends Node2D

@export_group("Nodes")
@export var truck: Node2D
@export var ground: TileMapLayer
@export var attack_area: Area2D

var crew_data: Array[CharacterData]: 
	get: return GameState.characters

var crew_scenes: Dictionary[CharacterData.CharacterClass, PackedScene] = {
	CharacterData.CharacterClass.GUARD: preload("res://character/classes/guard/guard.tscn"),
	CharacterData.CharacterClass.GATHERER: preload("res://character/classes/gatherer/gatherer.tscn"),
}

var selected_crew: Array[CrewCharacter] = []
var selection_possible: bool = false


func _ready() -> void:
	#GameState.characters.append(load("res://character/data/guard_steve.tres"))
	#GameState.characters.append(load("res://character/data/guard_steve.tres"))
	for i in range(1):
		var character := CharacterData.new()
		#var random = CharacterData.CharacterClass.values().pick_random()
		var random = CharacterData.CharacterClass.GATHERER
		character.character_class = random
		character.name = str(i)
		crew_data.append(character)
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
