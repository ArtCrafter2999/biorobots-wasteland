extends Area2D
class_name BuildGhost

@export var sprite: Sprite2D
@export var collider: CollisionShape2D
@export var build_notifier: Sprite2D

var overlap: bool = false
var valid_icon: Texture2D = preload("res://truck/interior/upgrades/build_ghost/valid_placement_icon.tres")
var invalid_icon: Texture2D = preload("res://truck/interior/upgrades/build_ghost/invalid_placement_icon.tres")


func update_notifier(valid_placement: bool) -> void:
	if valid_placement:
		build_notifier.texture = valid_icon
	else:
		build_notifier.texture = invalid_icon


func _on_area_entered(area: Area2D) -> void:
	overlap = true
	print_debug("Overlap detected with: %s" % area.name)


func _on_area_exited(area: Area2D) -> void:
	overlap = false
	print_debug("Overlap ended with: %s" % area.name)
