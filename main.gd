extends Node
class_name GNpEditorRoot

const PROJECT_BUTTON = preload("res://scenes/buttons/ui_btn_project.tscn")

@onready var ui_editors = $CanvasLayer/VBoxContainer/Editors
@onready var ui_project_list_button = $CanvasLayer/VBoxContainer/MarginContainer/HBoxContainer/ScrollContainer/ProjectListButtons



func _enter_tree() -> void:
	GNp.root = self


func _ready() -> void:
	GNp.editor_added.connect(_on_editor_added)
	GNp.editor_removed.connect(_on_editor_removed)
	
	var project = GNpProject.new()
	GNp.new_editor(project)
	
	rebuild_project_buttons()
	

func _on_editor_added(index: int, editor: GNpEditor):
	rebuild_project_buttons()

func _on_editor_removed(index: int, editor: GNpEditor):
	rebuild_project_buttons()


func rebuild_project_buttons():
	for child in ui_project_list_button.get_children():
		child.queue_free()
	
	for editor in GNp.editors:
		var btn: Button = PROJECT_BUTTON.instantiate()
		btn.text = editor.project.name
		btn.editor = editor
		ui_project_list_button.add_child(btn)


func parent_editor(editor: GNpEditor):
	ui_editors.add_child(editor)
