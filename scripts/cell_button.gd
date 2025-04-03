extends Button
class_name Cell

var focus: bool = false
var correct_value: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if text != str(correct_value):
		add_theme_color_override("font_color", Color.RED)
		add_theme_color_override("font_focus_color", Color.RED)
		add_theme_color_override("font_hover_color", Color.RED)
	else:
		add_theme_color_override("font_color", Color.WHITE)
		add_theme_color_override("font_focus_color", Color.WHITE)
		add_theme_color_override("font_hover_color", Color.WHITE)

func _input(event: InputEvent) -> void:
	if focus:
		for i in range(9):
			if Input.is_key_pressed(KEY_1 + i):
				text = str(i+1)

func _on_focus_entered() -> void:
	focus = true

func _on_focus_exited() -> void:
	focus = false
