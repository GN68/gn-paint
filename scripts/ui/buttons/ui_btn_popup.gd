extends Button

@onready var popup: PopupMenu = get_child(0)

func _ready() -> void:
	pressed.connect(_on_button_pressed)

func _on_button_pressed():
	popup.popup(Rect2(-64,0,64,64))
