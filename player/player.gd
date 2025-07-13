extends CharacterBody2D
class_name Player

@export_category("Properties")
@export_range(100.0, 1000.0) var speed: float = 10.0


func _physics_process(_delta: float) -> void:
    var direction: Vector2 = Input.get_vector(&"move_left", &"move_right", &"move_up", &"move_down")
    velocity = direction * speed

    move_and_slide()