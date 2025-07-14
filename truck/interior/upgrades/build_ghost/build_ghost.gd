extends Area2D
class_name BuildGhost

@export var sprite: Sprite2D
@export var collider: CollisionShape2D
@export var build_notifier: Sprite2D

var overlap: bool = false


func update_notifier(color: Color) -> void:
	build_notifier.modulate = color


func _on_area_entered(area: Area2D) -> void:
	overlap = true
	print_debug("Overlap detected with: %s" % area.name)


func _on_area_exited(area: Area2D) -> void:
	overlap = false
	print_debug("Overlap ended with: %s" % area.name)
