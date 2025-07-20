extends StateBase

@export var attack_damage: float = 25;
@export var after_attacking_state: StateBase

@onready var character: Enemy = $"../.."
@onready var attack_range: Area2D = $AttackRange

var target_character: CrewCharacter;

func _state_check_enter():
	return attack_range.get_overlapping_bodies().any(func (character: Character): 
		return not character.is_dead)

func _state_enter():
	if not target_character:
		if attack_range.has_overlapping_bodies():
			target_character = attack_range.get_overlapping_bodies() \
					.filter((func (character: Character): 
							return not character.is_dead)) \
					.pick_random();
		else:
			machine.change_state(after_attacking_state);
			return;
	character.animation_player.play("attack");

func attack():
	if attack_range.get_overlapping_bodies() \
			.filter((func (character: Character): 
					return not character.is_dead)) \
			.has(target_character):
		target_character.take_damage(attack_damage)
	await character.animation_player.animation_finished
	machine.change_state(after_attacking_state);
