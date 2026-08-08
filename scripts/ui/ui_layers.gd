extends PanelContainer
class_name GNpEditorLayers


const LAYER_BUTTON = preload("uid://d0b6lae7e8rkw")

@onready var ui_list = $VBoxContainer/ScrollContainer/VBoxContainer
@onready var editor := GNp.get_editor(self)

func _ready() -> void:
	await editor.prepared
	editor.project.layer_added.connect(_on_layer_added)
	editor.project.layer_removed.connect(_on_layer_removed)
	rebuild_buttons()

func _on_layer_added(index: int, layer: GNpLayer):
	rebuild_buttons()


func _on_layer_removed(index: int, layer: GNpLayer):
	rebuild_buttons()


func rebuild_buttons():
	for child in ui_list.get_children():
		child.queue_free()
	
	for layer in editor.project.layers:
		var button = LAYER_BUTTON.instantiate()
		ui_list.add_child(button)
