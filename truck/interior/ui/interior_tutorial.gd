extends Control

signal Tutorial_Completed


func _ready() -> void:
    if not GameState.first_inside_load:
        queue_free()


func _on_button_pressed() -> void:
    GameState.first_inside_load = false
    Tutorial_Completed.emit()
    queue_free()