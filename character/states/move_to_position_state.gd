extends StateBase

@onready var character: CharacterBody2D = $"../.."

@export_range(50.0, 200.0) var speed: float = 50;
var after_state: StateBase
var target_position: Vector2;

func _state_enter_c(context: Dictionary):
	target_position = context[&"position"]
	after_state = context[&"next_state"]

func _physics_process(delta: float) -> void:
	if global_position.distance_squared_to(target_position) < 1:
		machine.change_state(after_state);
		return;
	var direction = global_position.direction_to(target_position)
	character.velocity = direction * speed

	character.move_and_slide()
