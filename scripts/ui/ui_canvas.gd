extends Node2D
class_name GNpEditorCanvas

@onready var ui_overlays = $Overlays
@onready var ui_layers = $Layers

# Recommended version, location independent
const CV_LAYER = preload("uid://d18r22n6l8wkw")


func _ready() -> void:
	GNp.active_project_changed.connect(_on_active_project_changed)

func _on_active_project_changed(project: GNpProject,last_project: GNpProject):
	if last_project:
		last_project.layer_added.disconnect(_on_layer_added)
		last_project.layer_removed.disconnect(_on_layer_removed)
	
	if project:
		project.layer_added.connect(_on_layer_added)
		project.layer_removed.connect(_on_layer_removed)
	rebuild_ui_layers()


func _on_layer_added(index: int, layer: GNpLayer):
	rebuild_ui_layers()


func _on_layer_removed(index: int, layer: GNpLayer):
	rebuild_ui_layers()


#TODO: swap to a more sophisticated method
func rebuild_ui_layers():
	for child in ui_layers.get_children():
		child.queue_free()
	
	var c = 0
	for layer in GNp.active_project.layers:
		c += 1
		var ui_layer:GNpLayerRenderer = CV_LAYER.instantiate()
		ui_layers.add_child(ui_layer)
		ui_layer.name = str("Layer",c)
		ui_layer.setup(layer)
