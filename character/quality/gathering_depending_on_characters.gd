extends Quality

@export var gathering_speed_modifier := 1.5
@onready var area: Area2D = $Area

func _physics_process(delta: float) -> void:
	if area.has_overlapping_bodies():
		character.gathering_mulitpliers[key] = gathering_speed_modifier
	else:
		character.gathering_mulitpliers.erase(key)
