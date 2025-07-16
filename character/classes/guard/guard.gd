extends CharacterBody2D
class_name CharacterGuard

@export_category("Properties")
@export var character_data: CharacterData
@export var move_speed: float = 100.0
@export var max_health: float = 100.0
@export_group("Nodes")
@export var sprite: AnimatedSprite2D

var health: float = max_health

var target_position: Vector2 = Vector2.ZERO


func play_animation(animation: String):
	sprite.play(animation)
	print_debug("Playing animation: %s" % animation)


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("interact"):
		print_debug("%s selected" % character_data.name)


# region STATES

func _on_idle_state_entered() -> void:
	play_animation("idle")
	print_debug("%s entered idle state" % character_data.name)
