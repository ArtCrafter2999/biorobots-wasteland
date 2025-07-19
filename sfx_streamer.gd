extends AudioStreamPlayer2D
class_name SFXStreamer

@export var sfx: Dictionary[String, AudioStream]

var current_sfx: String = ""


func play_file(file_name: String) -> void:
	if file_name == current_sfx:
		#print_debug("SFX already playing %s" % file_name)
		return
	if not sfx.has(file_name):
		push_warning("SFX %s not found" % file_name)
		return
	current_sfx = file_name
	stream = sfx[file_name]
	play()
	

func _on_finished() -> void:
	current_sfx = ""
