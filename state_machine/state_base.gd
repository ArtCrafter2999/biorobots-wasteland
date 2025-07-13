extends Node2D
class_name StateBase

var can_reenter: bool = false;

var machine: StateMachine;

func safe_enter(machine: StateMachine, context: Dictionary = {}):
	if self.machine != machine:
		self.machine = machine;
	_state_enter_c(context);
func _state_input(event: InputEvent):
	pass

## This called when the state was entered. See also [method StateBase._state_enter]
## You can read additional [param context] comming from the previous state
func _state_enter_c(context: Dictionary):
	_state_enter();
## This called when the state was entered.
## use this to set up initial variables, properties, start timer, 
## start playing animation or audio. [br]
## You can use [method StateBase._state_enter_c] if you need a context from pevious
## state (for example moving direction). [br]
## [color=#BBBB00]NOTE: this method will not be called if 
## [method StateBase._state_enter_c] is overriden [/color]
func _state_enter():
	pass
	
func _state_process_d(delta: float):
	_state_process();
func _state_process():
	pass
	
func _state_physics_process_d(delta: float):
	_state_physics_process();
func _state_physics_process():
	pass

func _state_exit_c(context: Dictionary = {}):
	_state_exit();
func _state_exit():
	pass
