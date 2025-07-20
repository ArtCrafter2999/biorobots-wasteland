class_name DeathState
extends StateBase

@export var saved_nodes: Array[Node] = [];
@export var deleted_nodes: Array[Node] = [];

@onready var character: Character = $"../.."

func _ready() -> void:
	character.on_death.connect(func ():
			machine.change_state(self))

func _state_enter():
	character.play_sfx("death");
	character.animation_player.play("death")
	var new_node = Node2D.new();
	character.get_parent().add_child(new_node)
	
	for node in deleted_nodes:
		node.queue_free()
	for node in saved_nodes:
		node.reparent(new_node)
	character.queue_free();
