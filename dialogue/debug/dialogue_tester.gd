extends Area2D

@export var dialogue: DialogueResource

func _on_body_entered(body: Node2D) -> void:
	DialogueManager.show_dialogue_balloon(dialogue, "start")
