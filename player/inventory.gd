extends Node
class_name Inventory

signal Inventory_Updated

@export var inventory: Dictionary = {}


func _ready() -> void:
	add_item("junk", 999)


func add_item(item: String, amount: int = 1) -> void:
	if item in inventory:
		inventory[item] += amount
	else:
		inventory[item] = amount
	print_debug("Added %s %s to inventory." % [amount, item])
	Inventory_Updated.emit()


func remove_item(item: String, amount: int = 1) -> void:
	if item in inventory:
		inventory[item] -= amount
		if inventory[item] <= 0:
			inventory.erase(item)
	print_debug("Removed %s %s from inventory." % [amount, item])
	Inventory_Updated.emit()


func get_item_amount(item: String) -> float:
	if item in inventory:
		return inventory[item]
	return 0
