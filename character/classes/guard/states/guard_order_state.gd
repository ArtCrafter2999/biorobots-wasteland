extends OrderState

@export var circle_distance: float = 50;

@onready var dull_timer: Timer = $DullTimer

var positioned = false;
var base_target_position: Vector2
var do_position := false;

func _state_enter():
	super._state_enter();
	do_position = character.crew_manager.selected_crew.size() > 1
	base_target_position = target_position;
	target_position += Vector2(randf_range(-20, 20), randf_range(-20, 20))
	positioned = false;

func _finished_traveling():
	dull_timer.start()
	await dull_timer.timeout;
	if not positioned and do_position:
		positioned = true;
		_prev_finished = false;
		var random_direction = Vector2.from_angle(randf() * TAU)
		target_position += random_direction * circle_distance
	else: 
		super._finished_traveling();
	
