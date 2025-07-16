class_name CrewCharacter
extends CharacterBody2D

var character_id: int;
@export var character_data: CharacterData:
	get:
		if character_data: 
			return character_data
		return GameState.characters[character_id]
	set(value):
		character_data = value

var gathering_mulitpliers := {}
var health_multipliers := {}

func get_gathering_multiplier():
	var muliplier: float = 1;
	for key in gathering_mulitpliers:
		muliplier *= gathering_mulitpliers[key];
	return muliplier
func get_health_multiplier():
	var muliplier: float = 1;
	for key in health_multipliers:
		muliplier *= health_multipliers[key];
	return muliplier
