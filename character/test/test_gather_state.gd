extends StateBase

@export var max_storage = 1
@export var go_home_state: StateBase
@onready var gatherable_checker: Area2D = $GatherableChecker

var gathering_speed = 0.029;

var biomass = 0;

func _state_enter():
	biomass = 0;

func _state_process_d(delta: float):
	var gatherable = gatherable_checker.get_overlapping_areas().pick_random() as Gatherable
	if not is_instance_valid(gatherable):
		machine.change_state(go_home_state)
		return
	biomass += gatherable.gather(min(gathering_speed * delta, max_storage - biomass))
	if is_equal_approx(biomass, 1):
		machine.change_state(go_home_state)
