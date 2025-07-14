extends Area2D
class_name BuildGhost

@export var sprite: Sprite2D
@export var collider: CollisionShape2D
@export var build_notifier: Sprite2D

var overlap: bool = false


func _on_area_entered(area: Area2D) -> void:
	overlap = true
	build_notifier.modulate = Color.RED


func _on_area_exited(area: Area2D) -> void:
	overlap = false
	build_notifier.modulate = Color.GREEN
