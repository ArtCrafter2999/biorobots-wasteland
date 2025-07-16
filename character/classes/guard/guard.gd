extends CrewCharacter
class_name CrewGuard

signal Crew_Selected(member: CharacterBody2D)
signal Crew_Selection_Possible(is_possible: bool)

@export_category("Properties")
@export var move_speed: float = 100.0
@export var attack_range: float = 100.0
@export_group("Nodes")
@export var statechart: StateChart
@export var sprite: AnimatedSprite2D
@export var selected_notifier: Sprite2D
@export var attack_zone: Area2D
@export var attack_timer: Timer

var target_position: Vector2 = Vector2.ZERO
var attack_target: CharacterBody2D = null
var enemies_in_range: Array[CharacterBody2D] = []
var bullet_scene: PackedScene = preload("res://character/classes/guard/bullet.tscn")


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
	sprite.sprite_frames = character_data.sprite_frames
	attack_zone.get_node("CollisionShape2D").shape.radius = attack_range


func _physics_process(_delta: float) -> void:
	if enemies_in_range.size() > 0:
		if not attack_timer.is_stopped():
			return

		var closest_enemy: CharacterBody2D = _get_closest_enemy()
		var attack_direction: Vector2 = global_position.direction_to(closest_enemy.global_position)

		var bullet: CharacterBody2D = bullet_scene.instantiate()
		bullet.target_direction = attack_direction
		bullet.global_position = global_position
		get_parent().add_child(bullet)

		attack_timer.start()
		print_debug("Attacked enemy at %s" % closest_enemy.global_position)


func _get_closest_enemy() -> CharacterBody2D:
	var closest_enemy: CharacterBody2D = null
	for enemy in enemies_in_range:
		if closest_enemy == null:
			closest_enemy = enemy
			continue
		if enemy.global_position.distance_to(global_position) < closest_enemy.global_position.distance_to(global_position):
			closest_enemy = enemy
	return closest_enemy


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("interact"):
		select_self()


func _on_mouse_entered() -> void:
	Crew_Selection_Possible.emit(true)


func _on_mouse_exited() -> void:
	Crew_Selection_Possible.emit(false)


func _handle_movement(_delta: float) -> void:
	var direction: Vector2 = global_position.direction_to(target_position)
	velocity = direction * move_speed
	move_and_slide()


func _on_attack_area_body_entered(body: Node2D) -> void:
	if body is Enemy:
		enemies_in_range.append(body)


func _on_attack_area_body_exited(body: Node2D) -> void:
	if body in enemies_in_range:
		enemies_in_range.erase(body)

# region STATES

func _on_idle_state_entered() -> void:
	play_animation("idle")
	print_debug("%s entered idle state" % character_data.name)


func _on_move_to_position_state_physics_processing(_delta: float) -> void:
	if target_position == Vector2.ZERO:
		print_debug("%s's target position is zero" % character_data.name)
		return
	if global_position.distance_to(target_position) < 5:
		print_debug("Target position reached")
		send_state_event("target_pos_reached")
		target_position = Vector2.ZERO
		return

	_handle_movement(_delta)
