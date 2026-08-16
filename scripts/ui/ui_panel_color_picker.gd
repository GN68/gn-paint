extends PanelContainer


@onready var color_picker: ColorPicker = $VBoxContainer/HBoxContainer/VBoxContainer/ColorPicker

@onready var hex_line_edit: LineEdit = $VBoxContainer/HBoxContainer/VBoxContainer/MarginContainer/HBoxContainer2/ColorSliders/HBoxContainer/VBoxContainer/HBoxContainer/HexLineEdit



func _ready() -> void:
	update_ui_colors()
	GNp.color_changed.connect(_on_color_changed	)

func _on_color_changed(clr1: Color,clr2: Color):
	update_ui_colors()

func _on_color_picker_color_changed(color: Color) -> void:
	GNp.color_primary = color


func update_ui_colors():
	var color = GNp.color_primary
	color_picker.color = color
	var with_alpha: bool = color.a != 1
	hex_line_edit.text = color.to_html(with_alpha)


func _on_hex_line_edit_text_submitted(new_text: String) -> void:
	GNp.color_primary = Color.from_string(new_text,Color.BLACK)
