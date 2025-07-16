extends CharacterBody2D
class_name CrewGuard

signal Crew_Selected(member: CharacterBody2D)

@export_category("Properties")
@export var character_data: CharacterData
@export var move_speed: float = 100.0
@export_group("Nodes")
@export var statechart: StateChart
@export var sprite: AnimatedSprite2D
@export var selected_notifier: Sprite2D

var target_position: Vector2 = Vector2.ZERO
var attack_target: CharacterBody2D = null


func send_state_event(event: String) -> void:
	statechart.send_event(event)
	print_debug("Sending event: %s" % event)


func play_animation(animation: String):
	sprite.play(animation)
	print_debug("Playing animation: %s" % animation)


func select_self() -> void:
	Crew_Selected.emit(self)
	selected_notifier.show()
	print_debug("%s selected" % character_data.name)


func unselect_self() -> void:
	selected_notifier.hide()
	print_debug("%s unselected" % character_data.name)


func _ready() -> void:
	selected_notifier.hide()


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("interact"):
		select_self()


# region STATES

func _on_idle_state_entered() -> void:
	play_animation("idle")
	print_debug("%s entered idle state" % character_data.name)


func _on_move_to_position_state_physics_processing(_delta: float) -> void:
	if target_position == Vector2.ZERO:
		print_debug("Target position is zero")
		return
	if global_position.distance_to(target_position) < 1:
		print_debug("Target position reached")
		send_state_event("target_pos_reached")
		return

	var direction: Vector2 = global_position.direction_to(target_position)
	velocity = direction * move_speed
	move_and_slide()
