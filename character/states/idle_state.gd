extends StateBase

@onready var character: CrewCharacter = $"../.."

func _state_enter():
	if not character.animation_player:
		await get_tree().process_frame
	
	character.animation_player.play("idle")
