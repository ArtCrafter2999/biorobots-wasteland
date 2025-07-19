extends StateBase

@export var walking_modificator = 0.5

@onready var idle_timer: Timer = $IdleTimer
@onready var character: Enemy = $"../.."

var is_walking := false
var walking_direction: Vector2;

func _ready() -> void:
	idle_timer.timeout.connect(_idle_timer_timeout)

func _state_enter():
	if not character.animation_player:
		await get_tree().process_frame;
	character.animation_player.play("idle")
	_restart_timer();

func _state_physics_process(_delta) -> void:
	if not is_walking:
		character.animation_player.play("idle")
		return;
	else:
		character.animation_player.play("move")
		character.move(walking_direction, walking_modificator)

func _state_exit() -> void:
	idle_timer.stop();

func _idle_timer_timeout():
	is_walking = not is_walking
	walking_direction = Vector2.from_angle(randf() * TAU)
	_restart_timer();

func _restart_timer():
	idle_timer.wait_time = randf_range(3, 5)
	idle_timer.start()
