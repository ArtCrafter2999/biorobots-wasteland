extends StateBase

@onready var character: CrewCharacter = $"../.."

func _state_enter():
	if not character.sprite:
		await get_tree().process_frame
	
	character.sprite.play("idle")
