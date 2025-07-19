extends Node

var sprite_dir: String = "res://region/"
var sprites: Dictionary[String, Array] = {
	"building": [],
	"broken_building": [],
	"container": [],
	"pond": [],
	"dry_pond": [],
	"dead_tree": [],
	"boxes": [],
	"ruins": [],
	"rocks": [],
	"shrubs": [],
}


func _ready() -> void:
	for key in sprites:
		load_sprites(key)


func load_sprites(key: String) -> void:
	var dir_path: String = sprite_dir.path_join(key)
	var dir = DirAccess.open(dir_path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir():
				if file_name.get_extension() == "tres":
					var full_path = sprite_dir.path_join(key).path_join(file_name)
					sprites[key].append(load(full_path))
			file_name = dir.get_next()
		print_debug("Loaded %s sprites from \"%s\"" % [sprites[key].size(), dir_path])
	else:
		push_error("Invalid sprite dir: \"%s\"" % sprite_dir)
