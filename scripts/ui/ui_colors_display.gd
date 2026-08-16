extends Control

@onready var button_color_primary: Button = $Control/ButtonColorPrimary
@onready var display_color_primary: ColorRect = $Control/ButtonColorPrimary/ColorPrimary
@onready var button_color_secondary: Button = $Control/ButtonColorSecondary
@onready var display_color_secondary: ColorRect = $Control/ButtonColorSecondary/ColorSecondary

func _ready() -> void:
	GNp.color_changed.connect(_on_color_changed)
	update_colors()

func _on_color_changed(clr_primary: Color, clr_secondary: Color):
	update_colors()

func update_colors():
	display_color_primary.color = GNp.color_primary
	display_color_secondary.color = GNp.color_secondary

func _on_swap_colors_button_pressed() -> void:
	GNp.swap_colors()


func _on_reset_color_button_pressed() -> void:
	GNp.set_color_primary(Color.BLACK)
	GNp.set_color_secondary(Color.WHITE)


func _on_button_color_secondary_pressed() -> void:
	GNp.swap_colors()
