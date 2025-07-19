extends CharacterBody2D

@export var speed: float = 450.0
@export var damage: float = 10.0
@export var speed_curve: Curve;

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var destroy_timer: Timer = $DestroyTimer

var enemies_damaged: Array[Enemy] = []

var actual_speed
var target_direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	actual_speed = speed + randf_range(-20, 20)

func _physics_process(_delta: float) -> void:
	actual_speed *= speed_curve.sample(destroy_timer.wait_time - destroy_timer.time_left)
	velocity = target_direction * actual_speed
	rotation = global_position.angle_to(target_direction)
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Enemy and not enemies_damaged.has(body):
		enemies_damaged.append(body)
		body.take_damage(damage)

func _on_destroy_timer_timeout() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(sprite_2d, "modulate", Color.TRANSPARENT, 0.2);
	await tween.finished;
	queue_free();
