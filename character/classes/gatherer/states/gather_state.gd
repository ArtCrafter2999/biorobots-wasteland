extends StateBase

@onready var gatherer: CrewGatherer = $"../.."

@export var max_storage = 1
@export var go_home_state: StateBase
@export var no_gatherable_state: StateBase
@onready var gatherable_checker: Area2D = $GatherableChecker
@onready var gatherable_finder: Area2D = $GatherableFinder

var gatherable_target: Gatherable;

func _state_check_enter():
	if gatherable_finder.has_overlapping_areas():
		return true;
	return false

func _state_enter():
	gatherer.animation_player.play("gather")
	_pick_nearest_gatherable();
	
	gatherer.crew_manager.unselect_crew(gatherer)
	
	if not gatherable_target:
		machine.change_state(no_gatherable_state);

func _state_process(delta: float):
	if not gatherable_target:
		_pick_nearest_gatherable();
		if not gatherable_target:
			machine.change_state(no_gatherable_state);
			return
	if not gatherable_checker.get_overlapping_areas().has(gatherable_target):
		gatherer.move(global_position.direction_to(gatherable_target.global_position))
		return;
	
	if not is_instance_valid(gatherable_target):
		machine.change_state(go_home_state)
		return
	gatherer.biomass += gatherable_target.gather(min(CrewGatherer.GATHERING_SPEED * delta, max_storage - gatherer.biomass))
	if is_equal_approx(gatherable_target.value, 0):
		gatherable_target.destroy();


func _state_exit():
	gatherable_target = null;

func _pick_nearest_gatherable():
	var gatherables_area2d = gatherable_finder.get_overlapping_areas()
	if gatherables_area2d.is_empty():
		return
	
	var gatherables_node2d: Array[Node2D]
	for area in gatherables_area2d:
		gatherables_node2d.append(area as Node2D)
		
	gatherer.proximity_sort(gatherables_node2d)
	gatherable_target = gatherables_node2d[0] as Gatherable
