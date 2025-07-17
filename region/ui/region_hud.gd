extends Control

@export var region_timer: Timer
@export var biomass_counter: RichTextLabel
@export var junk_counter: RichTextLabel
@export var time_counter: RichTextLabel


func _ready() -> void:
	PlayerInventory.connect(&"Inventory_Updated", _update_counters)
	show()


func _process(_delta: float) -> void:
	_update_counters()


func _update_counters() -> void:
	var time_left: int = int(region_timer.time_left) if region_timer else -1
	time_counter.text = "Sundown in %ss" % time_left
	biomass_counter.text = "Biomass - %d" % PlayerInventory.get_item_amount("biomass")
	junk_counter.text = "Junk - %d" % PlayerInventory.get_item_amount("junk")
