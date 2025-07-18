class_name CrewCharacter
extends CharacterBody2D

signal crew_selected(member: CharacterBody2D)
signal crew_selection_possible(is_possible: bool)

@export var move_speed: float = 100.0

@export var character_data: CharacterData:
	get:
		if character_data: 
			return character_data
		return GameState.characters[character_id]
	set(value):
		character_data = value

@export var order_state: OrderState;

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var selected_notifier: Sprite2D = $SelectNotifier
@onready var state_machine: StateMachine = $StateMachine

var character_id: int;
var gathering_mulitpliers := {}
var health_multipliers := {}
var move_speed_multipliers := {}

func _ready() -> void:
	selected_notifier.hide()
	if character_data.sprite_frames:
		sprite.sprite_frames = character_data.sprite_frames


func select_self() -> void:
	crew_selected.emit(self)
	selected_notifier.show()


func unselect_self() -> void:
	selected_notifier.hide()


func move(direction: Vector2, state_multiplier: float = 1) -> void:
	velocity = direction * move_speed * state_multiplier * \
			_get_multiplier(move_speed_multipliers)
	move_and_slide()


func _get_multiplier(dictionary: Dictionary):
	var muliplier: float = 1;
	for key in dictionary:
		muliplier *= dictionary[key];
	return muliplier


func _on_mouse_entered() -> void:
	crew_selection_possible.emit(true)


func _on_mouse_exited() -> void:
	crew_selection_possible.emit(false)


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("interact"):
		select_self()


func proximity_sort(nodes: Array[Node2D], from: Vector2 = global_position):
	nodes.sort_custom(func(node_a, node_b):
		var distance_a = node_a.global_position.distance_to(from)
		var distance_b = node_b.global_position.distance_to(from)
		return distance_a < distance_b
	)

func order(target_position: Vector2):
	order_state.target_position = target_position
	state_machine.change_state(order_state);
