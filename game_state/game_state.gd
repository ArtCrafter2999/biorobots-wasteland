extends Node

var crew_scenes: Dictionary[StringName, PackedScene] = {
	&"guard": preload("res://character/classes/guard/guard.tscn"),
	&"medic": null,
	&"gatherer": null,
	&"jobless": null,
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