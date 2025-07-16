extends Quality

@export var gathering_speed_modifier := 1.5
@onready var area: Area2D = $Area

func _ready() -> void:
	area.body_entered.connect(_body_entered)

func _body_entered(body: Node2D):
	if body is CrewCharacter:
		var character = body as CrewCharacter
		character.gathering_mulitpliers[key] = gathering_speed_modifier;
		
func _body_exited(body: Node2D):
	if body is CrewCharacter:
		var character = body as CrewCharacter
		character.gathering_mulitpliers.erase(key);
