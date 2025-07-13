extends CharacterBody2D

var character_id: int;
@export var character_data: CharacterData:
	get:
		if character_data: 
			return character_data
		return GameState.characters[character_id]
	set(value):
		character_data = value
