extends Button

var focus: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if focus:
		for i in range(9):
			if Input.is_key_pressed(KEY_1 + i):
				text = str(i+1)

func _on_focus_entered() -> void:
	focus = true

func _on_focus_exited() -> void:
	focus = false
