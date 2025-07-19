class_name CharacterAnimation
extends AnimationPlayer

@export var sprites: Array[Sprite2D]

var flip_h: bool = false:
	get:
		return sprites[0].flip_h
	set(value):
		for sprite in sprites:
			sprite.flip_h = value;

func play_animation(animation: StringName = &"") -> void:
	if current_animation != animation:
		stop(true)
	play(animation)
