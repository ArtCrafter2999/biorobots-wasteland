extends Node
class_name Inventory

signal Inventory_Updated(inventory: Dictionary)

@export var inventory: Dictionary = {}


func add_item(item: String, amount: int = 1) -> void:
	if item in inventory:
		inventory[item] += amount
	else:
		inventory[item] = amount
	print_debug("Added %s %s to inventory." % [amount, item])
	Inventory_Updated.emit(inventory)


func remove_item(item: String, amount: int = 1) -> void:
	if item in inventory:
		inventory[item] -= amount
		if inventory[item] <= 0:
			inventory.erase(item)
	print_debug("Removed %s %s from inventory." % [amount, item])
	Inventory_Updated.emit(inventory)


func check_inventory(item: String, amount: int) -> bool:
	var item_exists: bool = item in inventory and inventory[item] >= amount
	print_debug("Checked inventory for %s %s: %s" % [amount, item, item_exists])
	return item_exists