extends ProgressBar
class_name ProgresBarEdit

@export var sensitivity: float = 1.0

var origin_mpos: int
var original_value: int

var is_editing: bool = false
signal editing_started
signal editing_ended

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			var mpos = get_global_mouse_position().x
			var diff = (mpos-origin_mpos)
			value = original_value + diff / size.x * (max_value - min_value) * sensitivity
			accept_event()
	if Input.is_action_just_pressed("primary"):
		if !is_editing:
			original_value = value
			origin_mpos = get_global_mouse_position().x
			is_editing = true
			editing_started.emit()
	if Input.is_action_just_released("primary"):
		if is_editing:
			is_editing = false
			editing_ended.emit()
