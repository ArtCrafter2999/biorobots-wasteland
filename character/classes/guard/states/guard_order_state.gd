extends OrderState

@export var circle_distance: float = 50;

var positioned = false;
var base_target_position: Vector2

func _state_enter():
	super._state_enter();
	base_target_position = target_position;
	target_position += Vector2(randf_range(-30, 30), randf_range(-30, 30))
	positioned = false

func _finished_traveling():
	if not positioned:
		positioned = true;
		var random_direction = Vector2.from_angle(randf() * TAU)
		target_position += random_direction * circle_distance
	else: 
		super._finished_traveling();
