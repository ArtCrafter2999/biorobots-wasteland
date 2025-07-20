extends Node2D

@export var pool: Array[PackedScene] = [] 

@export var square_size: int = 1000;
@export var value: float = 100;

func _ready() -> void:
	generate();

func generate():
	var value_left = max(value - GameState.day_count * 3, 1);
	var taken_points: Array[Vector2] = [];
	
	while value_left > 0:
		var gatherable = pool.pick_random().instantiate() as Gatherable
		
		var points: Array[Vector2] = []
		var point: Vector2 
		# check if any point overlap with already taken
		while points.size() == 0 or points.any(func (p): p in taken_points):
			# get random point in range
			point = Vector2(randi_range(0, square_size), randi_range(0, square_size)) \
					#snap to grid
					.snapped(Vector2(16, 16)) \
					# align to be centered
					- (Vector2.ONE * square_size / 2)
			points = [point]
			for x in range(gatherable.tiles_size.x):
				for y in range(gatherable.tiles_size.y):
					#append point for each tile of space taken
					points.append(Vector2(point.x + x, point.y + y))
		
		for p in points:
			taken_points.append(p);
		
		add_child(gatherable)
		gatherable.position = point;
		# less value for futher objects
		if gatherable.resource == "biomass":
			value_left -= gatherable.value * (point.distance_to(Vector2.ZERO) * 2 / square_size);
	print("objects count " + str(get_child_count() -2))
