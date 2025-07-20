extends StateBase

@export var see_noone_state: StateBase

@onready var character: Enemy = $"../.."
@onready var character_check: Area2D = $CharacterCheck
@onready var not_in_range_timer: Timer = $NotInRangeTimer

var target_character: CrewCharacter

func _ready() -> void:
	not_in_range_timer.timeout.connect(_not_in_range_timer_timeout)

func _state_check_enter():
	return character_check.has_overlapping_bodies();

func _state_enter():
	_target_nearest()

func _target_nearest():
	var bodies = character_check.get_overlapping_bodies() \
			.filter((func (character: Character): 
					return not character.is_dead));
	
	if bodies.size() == 0:
		return;
	
	character.proximity_sort(bodies)
	target_character = bodies[0]

func _state_physics_process(_delta: float):
	if not target_character or \
			not is_instance_valid(target_character) \
			or target_character.is_dead:
		if character_check.get_overlapping_bodies() \
			.any((func (character: Character): 
					return not character.is_dead)):
			_target_nearest();
		else:
			machine.change_state(see_noone_state);
			return;
	elif not character_check.get_overlapping_bodies().has(target_character):
		not_in_range_timer.start()
	else:
		not_in_range_timer.stop()
	character.move(global_position.direction_to(target_character.global_position));

func _state_exit():
	not_in_range_timer.stop();

func _not_in_range_timer_timeout():
	machine.change_state(see_noone_state);
