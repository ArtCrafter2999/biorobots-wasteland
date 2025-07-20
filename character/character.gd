class_name Character
extends CharacterBody2D

signal on_death;

@export var move_speed: float = 100.0
@export var health: float = 100.0
@export var sfx_player: AudioStreamPlayer2D

@onready var animation_player: CharacterAnimation = %Animation

var is_dead: bool: 
	get: return health <= 0;

func take_damage(damage: float) -> void:
	health -= damage
	play_sfx("hurt")
	if health <= 0:
		on_death.emit();

func move(direction: Vector2, multiplier: float = 1) -> void:
	velocity = direction * move_speed * multiplier
	if velocity:
		animation_player.play("move")
		animation_player.flip_h = velocity.x < 0;
		play_sfx("move")
	move_and_slide()

func proximity_sort(nodes: Array[Node2D], from: Vector2 = global_position):
	nodes.sort_custom(func(node_a, node_b):
		var distance_a = node_a.global_position.distance_to(from)
		var distance_b = node_b.global_position.distance_to(from)
		return distance_a < distance_b
	)

func play_sfx(file_name: String) -> void:
	if not sfx_player:
		print_debug("%s has no sfx_player" % self)
		return
	sfx_player.play_file(file_name)
