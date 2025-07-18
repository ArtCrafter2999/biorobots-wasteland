extends OrderState

@onready var dull_timer: Timer = $DullTimer

func _state_enter():
	super._state_enter();
	var range = character.crew_manager.selected_crew \
			.filter(func (crew): return crew is CrewGatherer).size() * 10;
	target_position += Vector2(randf_range(-range, range), randf_range(-range, range))

func _finished_traveling() -> void:
	dull_timer.start()
	await dull_timer.timeout
	machine.change_state(after_state);
