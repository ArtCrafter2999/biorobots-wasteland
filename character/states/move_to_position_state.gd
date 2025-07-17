class_name MoveToPositionState
extends StateBase

@export var after_state: StateBase
var target_position: Vector2;

@onready var character: CrewCharacter = $"../.."

func _state_enter():
	character.sprite.play("move")

func _state_physics_process(_delta: float) -> void:
	if global_position.distance_squared_to(target_position) < 1:
		machine.change_state(after_state);
		return;
	var direction = global_position.direction_to(target_position)

	character.move(direction)
