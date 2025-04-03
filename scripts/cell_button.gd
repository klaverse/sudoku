extends Button
class_name Cell

signal same_attribute(same_col: int, same_row: int, same_value_text: String)
signal deactivate_same_attribute(same_col: int, same_row: int, same_value_text: String)
signal change_value

var focus: bool = false
var correct_value: int = 0
var col: int = -1
var row: int = -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#connect("select_cell", _on_focus_entered)
	
	pass


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
				emit_signal("change_value")

func hover_same_attributes() -> void:
	pass

func _on_focus_entered() -> void:
	focus = true
	emit_signal("same_attribute", col, row, text)

func _on_focus_exited() -> void:
	focus = false
	emit_signal("deactivate_same_attribute", col, row, text)

func _on_same_attribute(same_col: int, same_row: int, same_value_text: String) -> void:
	if col == same_col || row == same_row || text == same_value_text:
		focus = true


func _on_deactivate_same_attribute(same_col: int, same_row: int, same_value_text: String) -> void:
	if col == same_col || row == same_row || text == same_value_text:
		focus = false
