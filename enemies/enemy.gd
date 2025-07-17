extends CharacterBody2D
class_name Enemy

@export var health: float = 100.0


func take_damage(damage: float) -> void:
	health -= damage
	if health <= 0:
		queue_free()
