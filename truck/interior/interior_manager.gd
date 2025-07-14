extends Node2D
class_name InteriorManager

@export var interior_hud: Control
@export var floor_tilemap: TileMapLayer
@export var upgrades_parent: Node2D

var upgrades: Dictionary = {
    "bed": {
        "cost": 10,
        "scene": preload("res://truck/interior/upgrades/bed.tscn"),
        "icon": preload("res://truck/interior/upgrades/icons/bed.tres"),
    },
    "water_storage": {
        "cost": 15,
        "scene": preload("res://truck/interior/upgrades/water_storage.tscn"),
        "icon": preload("res://truck/interior/upgrades/icons/water_storage.tres"),
    }
}
var placed_upgrades: Array[Vector2] = []

var build_mode: bool = false
var build_position: Vector2 = Vector2.ZERO
var build_notifier: Sprite2D = null
var build_notifier_texture: Texture2D = preload("res://truck/interior/upgrades/icons/build_icon.png")


func _ready() -> void:
    interior_hud._initiate_upgrade_list(upgrades)
    interior_hud.connect("Upgrade_Selected", _on_upgrade_selected)
    interior_hud.connect("Upgrade_Deselected", _on_upgrade_deselected)


func _process(_delta: float) -> void:
    if build_mode:
        build_notifier.global_position = get_global_mouse_position() + Vector2(5, -5)
        build_position = floor_tilemap.to_local(get_global_mouse_position())

        if build_position in placed_upgrades:
            build_notifier.modulate = Color.RED  # Red if position is occupied
        else:
            build_notifier.modulate = Color.GREEN  # Green if position is free


func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("pause"):
        print_debug("PAUSE GAME")


func _on_upgrade_selected(index: int) -> void:
    build_mode = true
    build_notifier = Sprite2D.new()
    build_notifier.texture = build_notifier_texture
    build_notifier.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
    add_child(build_notifier)


func _on_upgrade_deselected() -> void:
    build_mode = false
    if build_notifier:
        build_notifier.queue_free()
        build_notifier = null