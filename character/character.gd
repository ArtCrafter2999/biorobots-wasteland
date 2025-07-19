class_name Character
extends CharacterBody2D

@export var move_speed: float = 100.0
@export var health: float = 100.0

@onready var animation_player: CharacterAnimation = %Animation

var is_dead: bool: 
	get: return health < 0;

func take_damage(damage: float) -> void:
	health -= damage
	if health <= 0:
		queue_free()

func move(direction: Vector2, multiplier: float = 1) -> void:
	velocity = direction * move_speed * multiplier
	if velocity:
		animation_player.play("move")
		animation_player.flip_h = velocity.x < 0;
	move_and_slide()

func proximity_sort(nodes: Array[Node2D], from: Vector2 = global_position):
	nodes.sort_custom(func(node_a, node_b):
		var distance_a = node_a.global_position.distance_to(from)
		var distance_b = node_b.global_position.distance_to(from)
		return distance_a < distance_b
	)
