extends StateBase

@export var move_to_position_state: StateBase;
@export var square_side = 100;
var side = 1

func _state_enter():
	var target: Vector2;
	match side:
		1:
			target = Vector2(square_side, 0)
			side = 2
		2:
			target = Vector2(square_side, square_side)
			side = 3
		3:
			target = Vector2(0, square_side)
			side = 4
		4:
			target = Vector2(0, 0)
			side = 1
	machine.change_state(move_to_position_state, {&"position": target, &"next_state": self})
