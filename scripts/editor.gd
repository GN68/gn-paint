extends Control
class_name GNpEditor
## an instance of an editor

# Quick pointers
var camera: Camera2D
var ui_layers: GNpEditorLayers
var is_mouse_inside: bool = false

## The project this editor will interface from
## Note: this is only set once, opening to another project means instantiating another [GNpEditor]
var project: GNpProject :
	set = setup

signal prepared(project: GNpProject)

func _ready() -> void:
	camera = $Workspace/Camera2D
	ui_layers = $UI/LayersPanel

func setup(new_project: GNpProject):
	if project: return # only allow setting project once per workspace
	project = new_project
	camera.position = Vector2(project.resolution) / 2
	prepared.emit(project)


func set_active(state: bool):
	if visible != state:
		visible = state
		$Workspace.visible = state
		camera.enabled = state


func _gui_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("zoom_in"):
		camera.zoom.x = camera.zoom.x * 0.9
		camera.zoom.y = camera.zoom.x
		return
	if Input.is_action_just_pressed("zoom_out"):
		camera.zoom.x = camera.zoom.x * 1.1
		camera.zoom.y = camera.zoom.x
		return

func _input(event: InputEvent) -> void:
	if is_mouse_inside:
		if event is InputEventMouseMotion:
			if Input.is_action_pressed("pan"):
				camera.position -= event.relative / camera.zoom


func _on_mouse_entered() -> void:
	is_mouse_inside = true


func _on_mouse_exited() -> void:
	is_mouse_inside = false
