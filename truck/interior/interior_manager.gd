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
	},
}

var build_mode: bool = false
var valid_placement: bool = false
var build_ghost_scene: PackedScene = preload("res://truck/interior/upgrades/build_ghost/build_ghost.tscn")
var build_ghost: BuildGhost = null
var selected_upgrade: Dictionary = {}


func place_upgrade() -> void:
	if not valid_placement:
		print_debug("Invalid placement!")
		return
	if PlayerInventory.get_item_amount("junk") < selected_upgrade["cost"]:
		print_debug("Not enough junk to place upgrade!")
		return

	var upgrade_scene: PackedScene = selected_upgrade["scene"]
	var upgrade_instance: Node = upgrade_scene.instantiate()
	upgrade_instance.global_position = build_ghost.global_position
	equipment_parent.add_child(upgrade_instance)
	PlayerInventory.remove_item("junk", selected_upgrade["cost"])

	print_debug("Placed upgrade: %s at pos %s" % [selected_upgrade, build_ghost.global_position])


func recycle_crew_member(member: CharacterData) -> void:
	for child in get_children():
		if child is CrewCharacter and child.character_data == member:
			child.queue_free()
		else:
			print_debug("%s cannot be recycled" % member.name)


func _ready() -> void:
	interior_hud._initiate_upgrade_list(equipment)
	interior_hud.connect("Upgrade_Selected", _on_upgrade_selected)
	interior_hud.connect("Upgrade_Deselected", _on_upgrade_deselected)
	_spawn_characters()


func _process(_delta: float) -> void:
	if build_ghost:
		var mouse_pos: Vector2i = floor_tilemap.local_to_map(get_global_mouse_position())
		var mouse_pos_on_map: Vector2 = floor_tilemap.map_to_local(mouse_pos)

		if mouse_pos not in floor_tilemap.get_used_cells() or build_ghost.overlap:
			valid_placement = false
			build_ghost.update_notifier(false)
		else:
			valid_placement = true
			build_ghost.update_notifier(true)

		build_ghost.global_position = mouse_pos_on_map
		if Input.is_action_just_pressed("interact"):
			place_upgrade()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		print_debug("PAUSE GAME")
	
	if Input.is_action_just_pressed("interact") and build_ghost:
		place_upgrade()


func _spawn_characters() -> void:
	for character in GameState.get_instantiated_characters():
		var spawn_pos: Vector2 = Vector2(randf_range(-150, 150), randf_range(-150, 150))
		character.global_position = spawn_pos
		add_child(character)


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
