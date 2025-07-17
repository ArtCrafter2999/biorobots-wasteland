extends Node2D
class_name StateBase

@export var can_reenter: bool = false;
@export var check_enter_states: Array[StateBase] = [];

var machine: StateMachine;

func safe_enter(machine: StateMachine):
	if self.machine != machine:
		self.machine = machine;
	_state_enter();
func _state_input(event: InputEvent):
	pass

## This called when the state was entered.
## use this to set up initial variables, properties, start timer, 
## start playing animation or audio. [br]
func _state_enter():
	pass

## Called every process frame when state is active
func _state_process(delta: float):
	pass

## Called every physics frame when state is active
func _state_physics_process(delta: float):
	pass

func _state_exit():
	pass

func _state_check_other_enter() -> StateBase:
	for state in check_enter_states:
		if state._state_check_enter():
			return state;
	return null
	
func _state_check_enter() -> bool:
	return false;
