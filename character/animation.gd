extends Node2D

@onready var sprites: AnimationPlayer = $"../Sprites/AnimationPlayer"
#@onready var outline_right: AnimationPlayer = $"../OutlineRight/AnimationPlayer"

func play(animation: String):
	sprites.play(animation)
	#outline_right.play(animation)
