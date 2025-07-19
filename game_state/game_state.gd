extends Node

var crew_scenes: Dictionary[CharacterData.CharacterClass, PackedScene] = {
	CharacterData.CharacterClass.GUARD: preload("res://character/classes/guard/guard.tscn"),
	CharacterData.CharacterClass.GATHERER: preload("res://character/classes/gatherer/gatherer.tscn"),
}

var characters: Array[CharacterData] = []
var qualities_pool: Array[PackedScene]:
	get:
		if qualities_pool:
			return qualities_pool;
		
		var scene_loads: Array[PackedScene] = []	
		var path = "res://character/quality/qualities"
		var dir = DirAccess.open(path)
		if dir:
			dir.list_dir_begin()
			var file_name = dir.get_next()
			while file_name != "":
				if not dir.current_is_dir():
					if file_name.get_extension() == "tscn":
						var full_path = path.path_join(file_name)
						scene_loads.append(load(full_path))
				file_name = dir.get_next()
		else:
			print("An error occurred when trying to access the path.")

		qualities_pool = scene_loads;
		return scene_loads

func _ready() -> void:
	generate_crew(4)

func get_instantiated_characters() -> Array[CrewCharacter]:
	var instantiated_characters: Array[CrewCharacter] = []

	for crew_member in characters:
		var crew_member_scene: PackedScene = crew_scenes[crew_member.character_class]
		if crew_member_scene == null:
			print_debug("No scene found for %s" % crew_member.character_class)
			continue
		var crew_member_instance: CrewCharacter = crew_member_scene.instantiate()
		
		crew_member_instance.character_data = crew_member
		instantiated_characters.append(crew_member_instance)

	return instantiated_characters

func generate_crew(amount: int):
	var names = load_names();
	for i in range(amount):
		var character := CharacterData.new()
		#var ch_class = CharacterData.CharacterClass.values().pick_random()
		if i % 4 != 0:
			character.character_class = CharacterData.CharacterClass.GATHERER
		else:
			character.character_class = CharacterData.CharacterClass.GUARD
		character.name = names.pick_random()
		character.generate_colors();
		characters.append(character)



func load_names() -> Array[String]:
	var file = FileAccess.open("res://character/male_names.txt", FileAccess.READ)
	
	if file == null:
		printerr("Failed to open file, Error: ", FileAccess.get_open_error())
		return []
	var loaded_names: Array[String] = []
	while not file.eof_reached():
		var line = file.get_line()
		# Optionally, trim whitespace from the line
		line = line.strip_escapes().strip_edges()
		if not line.is_empty(): # Only add non-empty lines
			loaded_names.append(line)
	file.close()

	if loaded_names.is_empty():
		print("File is empty or contains only empty lines: ")
	
	return loaded_names
