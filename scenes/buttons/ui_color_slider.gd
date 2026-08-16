extends Button
class_name ButtonColorSlider

const DOUBLE_CLICK_DURATION: float = 0.2

const SHIFT_MULTIPLIER = 0.1

@export_range(0,255,1) var length: int = 255 : set = set_length
@export_range(0,255,1) var value: int = 128 : set = set_value
@export var texture: Texture : set = set_texture


@onready var texture_rect: TextureRect = $TextureRect
@onready var line_edit: LineEdit = $LineEdit
@onready var knob: Control = $Knob

signal value_changed(value: int)

var editing: bool = false
var _forced: bool = false

func _ready() -> void:
	# let a single frame to proces so all GUI sizes are finalized
	await RenderingServer.frame_post_draw 
	update_display()

func set_texture(new_texture):
	if texture != new_texture:
		texture = new_texture
		if not is_node_ready(): await ready
		texture_rect.texture = texture

func update_display():
	if not is_node_ready(): await ready
	line_edit.text = str(int(value))
	knob.position.x = float(value) / length * size.x


func set_value(new_value: int):
	if !editing or _forced:
		new_value = clampi(new_value,0,length)
		if value != new_value:
			value = new_value
			update_display()
			if _forced:
				value_changed.emit(new_value)


func set_length(new_length: int):
	length = new_length
	set_value(value)
	update_display()

var og_mpos: float
var og_value: int
func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				if event.double_click:
					line_edit.grab_focus()
					line_edit.select_all()
			else:
				if editing:
					editing = false

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if editing:
			_forced = true
			var mul = 1
			if Input.is_key_pressed(KEY_SHIFT):
				mul = SHIFT_MULTIPLIER
			set_value(og_value + (event.global_position.x - og_mpos) / size.x * length * mul)
			_forced = false

func _on_button_down() -> void:
	editing = true
	og_mpos = get_global_mouse_position().x
	og_value = value


func _on_line_edit_text_changed(new_text: String) -> void:
	pass # Replace with function body.


func _on_line_edit_text_submitted(new_text: String) -> void:
	if new_text.is_valid_int():
		value = clampi(int(new_text),0,length)
		value_changed.emit(value)
