extends StateBase

@export var go_to_state: StateBase
@export var gather_state: StateBase

var time: int = 0;
var overral_time: int = 0;
var biomass: int = 0

func _state_process():
	await get_tree().process_frame
	if global_position.distance_squared_to(Vector2.ZERO) < 1:
		if time:
			print("finieshed go home: %s ms" % str(Time.get_ticks_msec() - time))
			biomass += 1
		if Time.get_ticks_msec() - overral_time >= 180000:
			print("BIOMASS FOR 3 min: %s" % str(biomass - 1))
		var objects = find_parent("GenerationTest").find_children("*", &"Gatherable", false, false)
		if objects.size() == 0: return;
		objects.sort_custom(func(node_a, node_b):
				var distance_a = node_a.global_position.distance_to(Vector2.ZERO)
				var distance_b = node_b.global_position.distance_to(Vector2.ZERO)
				return distance_a < distance_b
		)
		var any_obj = objects[0] as Node2D
		
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
