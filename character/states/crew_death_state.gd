extends DeathState

@onready var crew_character: CrewCharacter = $"../.."

func _state_enter():
	crew_character.unselect();
	#var other_characters = get_tree().get_nodes_in_group(&"Characters") \
			#.filter(func (ch: CrewCharacter): 
					#return ch.character_id > crew_character.character_id);
	#for character: CrewCharacter in other_characters:
		#character.character_id-= 1
	GameState.characters.erase(crew_character.character_data);
	
	super._state_enter();
