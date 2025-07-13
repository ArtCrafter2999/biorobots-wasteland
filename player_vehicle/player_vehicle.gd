extends CharacterBody2D
class_name Player_Vehicle

@export_category("Properties")
@export_range(100.0, 1000.0) var speed: float = 10.0

@export_group("Controls")
@export var MOVE_UP: String = ""
@export var MOVE_DOWN: String = ""
@export var MOVE_LEFT: String = ""
@export var MOVE_RIGHT: String = ""


func _physics_process(delta: float) -> void:
    var direction: Vector2 = Input.get_vector(MOVE_LEFT, MOVE_RIGHT, MOVE_UP, MOVE_DOWN)
    velocity = direction * speed

    move_and_slide()