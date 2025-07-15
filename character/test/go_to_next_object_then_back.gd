extends StateBase

@export var go_to_state: StateBase
@export var gather_state: StateBase

var time: int = 0;
var overral_time: int = 0;
var biomass: int = 0

func _state_enter():
	await get_tree().process_frame
	if global_position.distance_squared_to(Vector2.ZERO) < 1:
		if time:
			print("finieshed go home: %s ms" % str(Time.get_ticks_msec() - time))
			biomass += 1
		if biomass == 4:
			print("GOAL REACHED at %s ms" % str(Time.get_ticks_msec() - overral_time))
		var objects = find_parent("GenerationTest").get_children()
		var any_obj = objects.pick_random() as Node2D
		
		if any_obj:
			machine.change_state(go_to_state, { 
					&"position": any_obj.position, 
					&"next_state": gather_state})
	else:
		print("finieshed go to obj: %s ms, distance: %s" % 
				[str(Time.get_ticks_msec() - time), global_position.distance_to(Vector2.ZERO)])
		machine.change_state(go_to_state, { 
				&"position": Vector2.ZERO, 
				&"next_state": self})
	time = Time.get_ticks_msec()
	if not overral_time:
		overral_time = time;
