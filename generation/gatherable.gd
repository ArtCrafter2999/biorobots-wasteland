class_name Gatherable
extends Area2D

@export var resource := "biomass"
@export var value: float = 1;
@export var tiles_size: Vector2i = Vector2i(1, 1);

func gather(amount: float): 
	var difference = value - amount;
	if difference > 0:
		value = difference
		return amount
	else:
		var left = value;
		value = 0;
		queue_free();
		print("free")
		return left
