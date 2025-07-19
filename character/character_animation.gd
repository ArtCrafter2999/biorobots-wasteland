class_name CharacterAnimation
extends AnimationPlayer

@export var sprites: Array[Sprite2D]
var character_data: CharacterData:
	get: return character_data;
	set(value):
		character_data = value;
		change_colors()

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

func change_colors():
	var skin_sprites = sprites.filter(func (sprite): 
			return ["Head"].has(sprite.name))
	var top_sprites = sprites.filter(func (sprite): 
			return ["LeftArm","RightArm", "Body"].has(sprite.name))
	var bottom_sprites = sprites.filter(func (sprite): 
			return ["LeftLeg", "RightLeg"].has(sprite.name))
	for sprite in skin_sprites:
		sprite.modulate = character_data.skin_tone;
	for sprite in top_sprites:
		sprite.modulate = character_data.top_color;
	for sprite in bottom_sprites:
		sprite.modulate = character_data.bottom_color;
