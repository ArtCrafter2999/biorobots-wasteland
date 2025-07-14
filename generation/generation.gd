extends Node2D

const TREE = preload("res://generation/tree.tscn")

@export var size: Vector2 = Vector2(1000, 1000);
@export_range(1, 100) var difficulty: float = 10;

func generate():
	print("generation")
	var difficulty_modifier = difficulty / 100
	var points_number = randf_range(100, 120) / difficulty_modifier
	if points_number > (size.x * size.y):
		points_number = (size.x * size.y) - (size.x * size.y / 10)
	var points = []
	#return;
	for i in range(points_number):
		var started = false
		var point: Vector2
		while not started or point in points:
			started = true;
			point = Vector2(randi_range(0, size.x), randi_range(0, size.y)) \
					.snapped(Vector2(16, 16)) - Vector2(size.x / 2, size.y / 2)
		points.append(point)
		#print(point)
		var tree = TREE.instantiate() as Node2D
		add_child(tree)
		tree.position = point;
