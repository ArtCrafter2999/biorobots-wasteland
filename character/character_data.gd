class_name CharacterData
extends Resource

enum CharacterClass {
	GATHERER,
	GUARD
}

@export var name: String
@export var character_class: CharacterClass
@export var max_health: float = 100.0
@export var qualities: Array[PackedScene] = []

var current_health: float = max_health
var is_dead: bool = false
