extends Node

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
