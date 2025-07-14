extends Node2D
class_name InteriorManager

@export var interior_hud: Control
@export var floor_tilemap: TileMapLayer
@export var equipment_parent: Node2D

var equipment: Dictionary = {
	"bed": {
		"cost": 10,
		"scene": preload("res://truck/interior/upgrades/bed.tscn"),
		"icon": preload("res://truck/interior/upgrades/icons/bed.tres"),
		"size": Vector2(1, 1),
	},
	"water_storage": {
		"cost": 15,
		"scene": preload("res://truck/interior/upgrades/water_storage.tscn"),
		"icon": preload("res://truck/interior/upgrades/icons/water_storage.tres"),
		"size": Vector2(1, 1),
	},
	"generator": {
		"size": Vector2(2, 1),
	},
	"door": {
		"size": Vector2(1, 1),
	},
}
var placed_upgrades: Array[Vector2] = []

var build_mode: bool = false
var build_ghost_scene: PackedScene = preload("res://truck/interior/upgrades/build_ghost/build_ghost.tscn")
var build_ghost: BuildGhost = null
var selected_upgrade: Dictionary = {}


func place_upgrade() -> void:
	var upgrade_scene: PackedScene = selected_upgrade["scene"]
	var upgrade_instance: Node = upgrade_scene.instantiate()
	upgrade_instance.global_position = floor_tilemap.map_to_local(build_ghost.global_position)
	equipment_parent.add_child(upgrade_instance)
	print_debug("Placed upgrade: %s at %s" % [selected_upgrade["scene"].resource_name, build_ghost.global_position])


func _ready() -> void:
	interior_hud._initiate_upgrade_list(equipment)
	interior_hud.connect("Upgrade_Selected", _on_upgrade_selected)
	interior_hud.connect("Upgrade_Deselected", _on_upgrade_deselected)


func _process(_delta: float) -> void:
	if build_ghost:
		var grid_pos: Vector2i = floor_tilemap.local_to_map(get_global_mouse_position())
		build_ghost.global_position = floor_tilemap.map_to_local(grid_pos)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		print_debug("PAUSE GAME")
		
	if event.is_action_pressed("interact"):
			if build_ghost.overlap:
				print_debug("Invalid placement!")
			else:
				place_upgrade()


func _create_build_ghost(texture: AtlasTexture, size: Vector2) -> void:
	var new_ghost: BuildGhost = build_ghost_scene.instantiate()
	new_ghost.sprite.texture = texture
	new_ghost.collider.shape.size = size * 16
	add_child(new_ghost)
	build_ghost = new_ghost


func _on_upgrade_selected(index: int) -> void:
	build_mode = true
	selected_upgrade = equipment[equipment.keys()[index]]
	_create_build_ghost(selected_upgrade.icon, selected_upgrade.size)

func _on_upgrade_deselected() -> void:
	build_ghost.queue_free()
	build_ghost = null
	selected_upgrade = {}
	build_mode = false
