extends OrderState

@export var circle_distance: float = 50;

var positioned = false;

func _state_enter():
	super._state_enter();
	positioned = false

func _finished_traveling():
	if not positioned:
		positioned = true;
		var random_direction = Vector2.from_angle(randf() * TAU)
		target_position += random_direction * circle_distance
	else: 
		super._finished_traveling();
