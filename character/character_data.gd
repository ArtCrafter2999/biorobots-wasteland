class_name CharacterData
extends Resource

enum CharacterClass {
	GATHERER,
	GUARD
}

const SKIN_TONES: Array[Color] = [
	Color("#C68642"), # Medium
	Color("#A96B3E"), # Medium Tan
	Color("#8D5524"), # Olive/Darker Tan
	Color("#6C3C1A"), # Dark
]

@export var name: String
@export var character_class: CharacterClass
@export var max_health: float = 100.0
@export var qualities: Array[PackedScene] = []
@export var skin_tone: Color;
@export var top_color: Color;
@export var bottom_color: Color;

var dictionary: Dictionary[CharacterClass, Dictionary] = {}

var current_health: float = max_health
var is_dead: bool = false

func generate_colors():
	if not skin_tone:
		skin_tone = SKIN_TONES.pick_random();
	if dictionary.has(character_class):
		top_color = dictionary[character_class][&"top_color"]
		bottom_color = dictionary[character_class][&"bottom_color"]
		return;
		
	match character_class:
		CharacterClass.GATHERER:
			top_color = generate_shade(Color.ORANGE)
			bottom_color = generate_shade(Color.ORANGE)
		CharacterClass.GUARD:
			top_color = generate_shade(Color.RED)
			bottom_color = generate_shade(Color.RED)
	
	dictionary[CharacterClass.GATHERER] = {&"top_color": top_color, &"bottom_color": bottom_color}

func generate_shade(base_color: Color) -> Color:
	var hue_variance: float = 0.10   # How much the hue can shift (e.g., 0.02 means +/- 2% of the hue circle)
	var sat_variance: float = 0.50  # How much the saturation can vary (e.g., +/- 15%)
	var val_variance: float = 0.50  # How much the value (brightness) can vary (e.g., +/- 15%)

	# Convert base color to HSV components
	var base_h = base_color.h
	var base_s = base_color.s
	var base_v = base_color.v

	# Generate random offsets for H, S, V within the defined variance
	var h_offset = randf_range(-hue_variance, hue_variance)
	var s_offset = randf_range(-sat_variance, sat_variance)
	var v_offset = randf_range(-val_variance, val_variance)

	# Apply offsets and clamp values to ensure they stay within valid ranges (0.0 to 1.0)
	# Hue wraps around, so we use `fmod` for that.
	var new_h = fmod(base_h + h_offset + 1.0, 1.0) # Add 1.0 to handle negative results from fmod
	var new_s = clamp(base_s + s_offset, 0.0, 1.0)
	var new_v = clamp(base_v + v_offset, 0.0, 1.0)

	# Convert back to Color object from HSV
	return Color.from_hsv(new_h, new_s, new_v)
