extends Node2D


var canvas_texture: DrawableTexture2D

@onready var CanvasRect = GNpEditorContext.canvas.texture_rect
@onready var WidthSpinbox = $UI/NewImageButton/ImageWizard/MarginContainer/VBoxContainer/WidthEntry/Spinbox
@onready var HeightSpinbox = $UI/NewImageButton/ImageWizard/MarginContainer/VBoxContainer/HeightEntry/Spinbox

var brush_pos: Vector2
var brush_target: Vector2

const STEP_SIZE = 2
const BRUSH_SIZE = 32

const BRUSH_SOLID = preload("res://shaders/brushes/solid.tres")

func new_canvas(width: int, height: int):
	canvas_texture = DrawableTexture2D.new()
	canvas_texture.setup(width,height,DrawableTexture2D.DRAWABLE_FORMAT_RGBA8)
	CanvasRect.texture = canvas_texture
	$Workspace/Camera2D.position = Vector2(WidthSpinbox.value / 2,HeightSpinbox.value / 2)



func process_brush(start: bool = false):
	var mouse_pos = CanvasRect.get_local_mouse_position()
	brush_target = mouse_pos
	
	if start:
		brush_pos = brush_target
	
	var vec_size = Vector2(BRUSH_SIZE,BRUSH_SIZE)
	var clr = $UI/ColorPickerButton.color
	
	for step in range(brush_pos.distance_to(brush_target) / STEP_SIZE):
		brush_pos += (brush_target-brush_pos).normalized() * STEP_SIZE
		BRUSH_SOLID.set_shader_parameter("resolution",BRUSH_SIZE)
		canvas_texture.blit_rect(Rect2i(brush_pos - vec_size / 2,vec_size),null,clr,0,BRUSH_SOLID)
	

func _ready() -> void:
	new_canvas(480,360)


func _on_open_image_button_pressed() -> void:
	$UI/OpenImageButton/FileDialog.popup_centered()


func _on_file_dialog_file_selected(path: String) -> void:
	var image = Image.load_from_file(path)
	
	var texture = ImageTexture.create_from_image(image)
	
	$Workspace/CanvasTexture.texture = texture


func _on_new_image_button_pressed() -> void:
	$UI/NewImageButton/ImageWizard.popup()


func _on_accept_button_pressed() -> void:
	$UI/NewImageButton/ImageWizard.visible = false
	new_canvas(WidthSpinbox.value,HeightSpinbox.value)


func _on_cancel_button_pressed() -> void:
	$UI/NewImageButton/ImageWizard.visible = false


func _on_canvas_texture_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			process_brush()
	if event is InputEventMouseButton:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			process_brush(true)


func _on_save_image_button_pressed() -> void:
	$UI/SaveImageButton/SaveImageDialog.popup_centered()



func _on_save_image_dialog_file_selected(path: String) -> void:
	var image = canvas_texture.get_image()
	
	var ext = path.get_extension()
	
	var err: int
	
	match ext:
		"dds":
			err = image.save_dds(path)
		"exr":
			err = image.save_exr(path)
		"jpg":
			err = image.save_jpg(path)
		"jpeg":
			err = image.save_jpg(path)
		"png":
			err = image.save_png(path)
		"webp":
			err = image.save_webp(path)
		_:
			err = image.save_png(path)
		
	print("saved image with exit code: ",err)
