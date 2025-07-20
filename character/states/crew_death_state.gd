extends DeathState

@onready var crew_character: CrewCharacter = $"../.."

func _state_enter():
	crew_character.unselect();
	GameState.characters[crew_character.character_id] = null;
	super._state_enter();
