class_name CharacterData
extends Resource

@export var name: String
@export var character_class: StringName
@export var max_health: float = 100.0
@export var qualities: Array[Quality] = []
@export var sprite_frames: SpriteFrames

var current_health: float = max_health
var is_dead: bool = false
