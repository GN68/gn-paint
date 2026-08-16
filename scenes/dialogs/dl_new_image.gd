extends ConfirmationDialog

@onready var height_spin_box: SpinBox = $VBoxContainer/HeightEntry/HeightSpinBox
@onready var width_spin_box: SpinBox = $VBoxContainer/WidthEntry/WidthSpinBox
@onready var background_color_picker_button: ColorPickerButton = $VBoxContainer/HeightEntry2/BackgroundColorPickerButton

func _on_confirmed() -> void:
	var project = GNpProject.new(
		width_spin_box.value,
		height_spin_box.value,
		background_color_picker_button.color
	)
	GNp.load_project(project)
