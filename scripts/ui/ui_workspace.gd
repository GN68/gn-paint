extends Node

@export var input_capturer: Control
@export var camera: Camera2D

@export_range(0.01, 0.2, 0.01) var zoomStepRatio: float = 0.1

@export var panButton: MouseButton = MOUSE_BUTTON_MIDDLE
@export var zoomInButton: MouseButton = MOUSE_BUTTON_WHEEL_UP
@export var zoomOutButton: MouseButton = MOUSE_BUTTON_WHEEL_DOWN

var last_mouse: Vector2

func _ready() -> void:
	input_capturer.canvas_input.connect(_canvas_input)

func _canvas_input(event: InputEvent) -> void:
	if not event is InputEventMouseButton and not event is InputEventMouseMotion:
		return

	var current_mouse := camera.get_local_mouse_position()

	if event is InputEventMouseMotion:
		if Input.is_mouse_button_pressed(panButton):
			camera.position -= event.relative

	if event is InputEventMouseButton and event.pressed:
		if event.button_index == zoomInButton:
			_zoom_at_cursor(1.0 / (1.0 - zoomStepRatio))
		elif event.button_index == zoomOutButton:
			_zoom_at_cursor(1.0 - zoomStepRatio)

	last_mouse = camera.get_local_mouse_position()


func _zoom_at_cursor(factor: float) -> void:
	var before := camera.get_global_mouse_position()
	camera.zoom = (camera.zoom * factor)
	var after := camera.get_global_mouse_position()
	camera.global_position += before - after
