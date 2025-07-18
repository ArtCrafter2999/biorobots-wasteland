extends StateBase

@onready var gatherer: CrewGatherer = $"../.."

@export var after_state: StateBase
var truck: Node2D

func _state_enter():
	if not truck:
		truck = get_tree().get_nodes_in_group("Truck")[0]

func _state_physics_process(_delta: float) -> void:
	if global_position.distance_to(truck.global_position) < 32:
		machine.change_state(after_state);
		return;
	var direction = global_position.direction_to(truck.global_position)

	gatherer.move(direction)

func _state_exit():
	PlayerInventory.add_item("biomass", gatherer.biomass)
	gatherer.biomass = 0;
