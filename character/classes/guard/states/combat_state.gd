extends StateBase

@export var order_state: StateBase

@onready var character: CrewCharacter = $"../.."
@onready var attack_range: Area2D = $AttackRange
@onready var attack_timer: Timer = $AttackTimer
@export var bullet_spread_angle_degrees: float = 20.0

var bullet_scene: PackedScene = preload("res://character/classes/guard/bullet.tscn")

func _state_check_enter():
	return attack_range.get_overlapping_bodies()\
			.any((func (character: Character): 
					return not character.is_dead));

func _state_enter():
	character.animation_player.play(&"draw")
	var name = await character.animation_player.animation_finished
	if name == &"draw":
		character.animation_player.play(&"shoot")

func _state_process(delta: float) -> void:
	var enemies = attack_range.get_overlapping_bodies() \
			.filter((func (character: Character): 
					return not character.is_dead));
	
	if enemies.is_empty():
		return;
		
	character.proximity_sort(enemies)
	var target = enemies[0]
	character.animation_player.flip_h = \
			global_position.direction_to(target.global_position).x < 0

func shoot():
	var enemies = attack_range.get_overlapping_bodies() \
			.filter((func (character: Character): 
					return not character.is_dead));
	
	if enemies.is_empty():
		machine.change_state(order_state);
		return;
		
	character.proximity_sort(enemies)
	var target = enemies[0]

	var attack_direction: Vector2 = global_position.direction_to(target.global_position)

	for i in range(randi_range(4,5)):
		var bullet: CharacterBody2D = bullet_scene.instantiate()
		
		# --- Add Spread ---
		var spread_radians = deg_to_rad(bullet_spread_angle_degrees / 2.0)
		var random_angle = randf_range(-spread_radians, spread_radians)
		
		# Rotate the attack_direction by the random angle
		# Assuming attack_direction is a normalized Vector2
		bullet.target_direction = attack_direction.rotated(random_angle)
		# --- End Spread ---
		
		bullet.global_position = global_position
		character.get_parent().add_child(bullet)
