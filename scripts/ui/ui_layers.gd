extends PanelContainer
class_name GNpEditorLayers

const LAYER_BUTTON = preload("uid://d0b6lae7e8rkw")


@onready var ui_list = $VBoxContainer/ScrollContainer/VBoxContainer

func _ready() -> void:
	GNp.active_project_changed.connect(_on_active_project_changed)

func _on_active_project_changed(project: GNpProject,last_project: GNpProject):
	if last_project:
		last_project.layer_added.disconnect(_on_layer_added)
		last_project.layer_removed.disconnect(_on_layer_removed)
		last_project.active_layer_changed.connect(_on_active_layer_changed)
	
	if project:
		project.layer_added.connect(_on_layer_added)
		project.layer_removed.connect(_on_layer_removed)
		project.active_layer_changed.connect(_on_active_layer_changed)
	rebuild_buttons()

func _on_layer_added(index: int, layer: GNpLayer):
	rebuild_buttons()


func _on_layer_removed(index: int, layer: GNpLayer):
	rebuild_buttons()


func _on_active_layer_changed(index: int, last_index: int):
	rebuild_buttons()


func rebuild_buttons():
	for child in ui_list.get_children():
		child.queue_free()
	
	for layer in GNp.active_project.layers:
		var button: GNpUILayerButton = LAYER_BUTTON.instantiate()
		ui_list.add_child(button)
		if layer == GNp.active_project.active_layer:
			button.theme_type_variation = &"ButtonHighlighted"
		button.set_layer(layer)
