@abstract
extends Node
class_name GNpTool

@export var tool_name: String
@export var tool_icon: CompressedTexture2D
@export var toolbar:HBoxContainer
@export var overlay:Node2D

var workspace: GNpLayerRenderer

func _ready() -> void:
	toolbar.visible = false
	overlay.visible = false

func _active_project_changed(project: GNpProject,last_project: GNpProject):
	if last_project: # Cause the active layer in the last project to save
		last_project.active_layer.workspace.confirm_proposal()


func _active_layer_changed(layer: GNpLayer, last_layer: GNpLayer):
	if last_layer:
		last_layer.workspace.confirm_proposal()
	workspace = layer.workspace

@abstract func _canvas_input(event: InputEvent) -> void

@abstract func _tool_process(delta: float) -> void
