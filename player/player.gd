extends Camera2D
class_name Player

@export_range(100.0, 1000.0) var speed: float = 200.0
@export_range(100.0, 1000.0) var zoom_speed: float = 0.4

func _physics_process(delta: float) -> void:
	var direction: Vector2 = Input.get_vector(
			&"move_left", 
			&"move_right", 
			&"move_up", 
			&"move_down")
	position += direction * speed * delta
	
	var zoom_axis = int(Input.is_action_just_released(&"zoom_in"))
	zoom_axis -= int(Input.is_action_just_released(&"zoom_out"))
	zoom = clamp(zoom + Vector2(zoom_axis, zoom_axis) * zoom_speed, Vector2.ONE, Vector2.ONE * 10);
