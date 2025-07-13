class_name Quality
extends Resource

enum QualityTrigger {
	GATHERING,
	MOVING,
}

@export var value: float = 0;
@export_range(0.0, 1.0, 0.01) var chance: float
@export var trigger: QualityTrigger = QualityTrigger.GATHERING;

func condition() -> bool:
	return _check_chance();

func _check_chance() -> bool:
	if randf() < chance / 100:
		return false
	return true
