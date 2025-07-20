extends Node2D

@export var max_enemies: int = 25
@export var scorpion_spawn_chance: float = 30.0

var enemy_scenes: Dictionary[String, PackedScene] = {
	"cayote": preload("res://enemies/cayote.tscn"),
	"scorpion": preload("res://enemies/scorpion.tscn"),
}

const TILE_SIZE: int = 16


func _ready() -> void:
	_spawn_enemies()


func _spawn_enemies() -> void:
	for i in range(max_enemies):
		var enemy_type: String = ""
		if randi() % 100 <= scorpion_spawn_chance:
			enemy_type = "scorpion"
		else:
			enemy_type = "cayote"
		
		var enemy: Enemy = enemy_scenes[enemy_type].instantiate()
		enemy.global_position = Vector2(
			randf_range(-50, 50) * TILE_SIZE,
			randf_range(-50, 50) * TILE_SIZE
		)
		add_child(enemy)

		print_debug("Spawned enemy %s at %s" % [enemy_type, enemy.global_position])
