extends Control

@onready var play_button: Button = $Play
@onready var play_option_button: OptionButton = $Play/OptionButton
@onready var board: Board = $"../../Board"

func _on_play_pressed() -> void:
	play_option_button.disabled = false
