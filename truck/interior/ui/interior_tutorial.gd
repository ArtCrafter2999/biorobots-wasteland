extends Control

signal Tutorial_Completed
signal Button_Clicked


func _ready() -> void:
    if not GameState.first_inside_load:
        queue_free()


func _on_button_pressed() -> void:
    Button_Clicked.emit()
    GameState.first_inside_load = false
    Tutorial_Completed.emit()
    queue_free()