extends StateBase

@export var order_state: StateBase

@onready var character: CrewCharacter = $"../.."
@onready var attack_range: Area2D = $AttackRange
@onready var attack_timer: Timer = $AttackTimer

var bullet_scene: PackedScene = preload("res://character/classes/guard/bullet.tscn")

func _state_check_enter():
	return attack_range.has_overlapping_bodies();

func _state_physics_process(_delta: float):
	var enemies = attack_range.get_overlapping_bodies()
	
	if enemies.is_empty():
		machine.change_state(order_state);
		return;
		
	character.proximity_sort(enemies)
	var target = enemies[0]
	
	if not attack_timer.is_stopped():
			return

	var attack_direction: Vector2 = global_position.direction_to(target.global_position)

	var bullet: CharacterBody2D = bullet_scene.instantiate()
	bullet.target_direction = attack_direction
	bullet.global_position = global_position
	character.get_parent().add_child(bullet)

	attack_timer.start()
	
