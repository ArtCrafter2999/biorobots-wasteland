extends Sprite2D

@export var type: String

func _ready() -> void:
	if type == "":
		push_error("Type is not set")
		return
	if not SpriteLoader.sprites.has(type):
		push_error("Invalid type: %s" % type)
		return
	
	var sprites: Array = SpriteLoader.sprites[type]
	texture = sprites.pick_random()
