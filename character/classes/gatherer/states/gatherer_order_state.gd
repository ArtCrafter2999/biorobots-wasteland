extends OrderState

func _state_enter():
	super._state_enter();
	target_position += Vector2(randf_range(-20, 20), randf_range(-20, 20))
