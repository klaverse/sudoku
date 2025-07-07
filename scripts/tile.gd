extends Button
class_name Tile

signal same_attribute(same_col: int, same_row: int, same_value_text: String)
signal deactivate_same_attribute(same_col: int, same_row: int, same_value_text: String)
signal change_value

var select: bool = false # is selected and ready to change value
var highlight: bool = false # is selected or the some same value tiles has selected
var correct_value: int = 0
var current_value: int = 0
var col: int = -1
var row: int = -1
var fixed: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#self.pressed.connect(_on_press)

func _on_press():
	select = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if self.current_value == 0:
		self.text = ""
	if self.text != str(self.correct_value):
		render_false_value()
	else:
		render_true_value()

func render_true_value():
	add_theme_color_override("font_color", Color.WHITE)
	add_theme_color_override("font_select_color", Color.WHITE)
	add_theme_color_override("font_hover_color", Color.WHITE)
	add_theme_color_override("font_color_focus", Color.WHITE)
	queue_redraw()

func render_false_value():
	add_theme_color_override("font_color", Color.RED)
	add_theme_color_override("font_select_color", Color.RED)
	add_theme_color_override("font_hover_color", Color.RED)
	add_theme_color_override("font_color_focus", Color.RED)
	queue_redraw()

func _input(event: InputEvent) -> void:
	if select:
		for i in range(9):
			if Input.is_key_pressed(KEY_1 + i):
				current_value = i+1
				text = str(i+1)
				emit_signal("change_value")

func hover_same_attributes() -> void:
	pass

func _on_focus_entered() -> void:
	select = true
	emit_signal("same_attribute", col, row, text)

func _on_focus_exited() -> void:
	select = false
	emit_signal("deactivate_same_attribute", col, row, text)

func _on_same_attribute(same_col: int, same_row: int, same_value_text: String) -> void:
	if col == same_col || row == same_row || text == same_value_text:
		select = true


func _on_deactivate_same_attribute(same_col: int, same_row: int, same_value_text: String) -> void:
	if col == same_col || row == same_row || text == same_value_text:
		select = false

#func highlight(is_on: bool):
	#if is_on:
		#self.add_theme_color_override("font_color", Color.YELLOW)
	#else:
		#self.add_theme_color_override("font_color", Color.WHITE)
