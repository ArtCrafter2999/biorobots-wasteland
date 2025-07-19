extends TileMapLayer

@export var region_size: Rect2i = Rect2i(-50, -50, 100, 100)


func _ready() -> void:
	_generate_ground(region_size)


func _generate_ground(area: Rect2i) -> void:
	var terrain_set_id = 0
	var sand_id = 0
	var cells: Array[Vector2i] = []

	for x in range(area.position.x, area.position.x + area.size.x):
		for y in range(area.position.y, area.position.y + area.size.y):
			cells.append(Vector2i(x, y))

	set_cells_terrain_connect(cells, terrain_set_id, sand_id)
