extends CharacterBody2D

@export var speed: float = 400.0
@export var damage: float = 10.0

var target_direction: Vector2 = Vector2.ZERO

func _physics_process(_delta: float) -> void:
	velocity = target_direction * speed
	rotation = global_position.angle_to(target_direction)
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Enemy:
		body.take_damage(damage)
		queue_free()
