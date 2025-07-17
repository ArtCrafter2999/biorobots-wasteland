class_name OrderState
extends StateBase

@export var after_state: StateBase
var target_position: Vector2;

@onready var character: CrewCharacter = $"../.."

func _state_enter():
	if not target_position or \
			global_position.distance_squared_to(target_position) < 1:
		machine.change_state(after_state);
		return;

func _state_physics_process(_delta: float):
	move_to_position(target_position);

func move_to_position(target_position: Vector2) -> void:
	if global_position.distance_squared_to(target_position) < 1:
		_finished_traveling();
		return;
	var direction = global_position.direction_to(target_position)

	character.move(direction)

func _finished_traveling() -> void:
	machine.change_state(after_state);
