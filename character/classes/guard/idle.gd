extends StateBase

signal Play_Anim(animation: String)

func _state_enter():
	Play_Anim.emit("idle")