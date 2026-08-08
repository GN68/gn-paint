extends Node2D
class_name GNpEditorCanvas

@onready var ui_overlays = $Overlays
@onready var ui_layers = $Layers

@onready var editor := GNp.get_editor(self)


func _ready() -> void:
	await editor.prepared
	editor.project.layer_added.connect(_on_layer_added)
	editor.project.layer_removed.connect(_on_layer_removed)
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
	for layer in editor.project.layers:
		c += 1
		var ui_layer = Sprite2D.new()
		ui_layer.name = str("Layer",c)
		ui_layer.texture = layer.texture
		ui_layer.centered = false
		ui_layers.add_child(ui_layer)
