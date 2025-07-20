extends Timer


func _ready() -> void:
	if not GameState.first_outside_load:
		start()


func _on_region_tutorial_tutorial_completed() -> void:
	start()
