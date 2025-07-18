class_name OrderState
extends StateBase

@export var after_state: StateBase

@onready var character: CrewCharacter = $"../.."

var target_position: Vector2;
var _prev_finished := false;

func _state_enter():
	_prev_finished = false;
	if not target_position or \
			global_position.distance_squared_to(target_position) < 1:
		machine.change_state(after_state);
		return;

func _state_physics_process(_delta: float):
	move_to_position(target_position);

func move_to_position(target_position: Vector2) -> void:
	if _prev_finished: return;
	if global_position.distance_squared_to(target_position) < 1:
		_prev_finished = true
		_finished_traveling();
		return;
	var direction = global_position.direction_to(target_position)

	character.move(direction)

func _finished_traveling() -> void:
	machine.change_state(after_state);
