extends Node
class_name GNpEditorRoot

const PROJECT_BUTTON = preload("res://scenes/buttons/ui_btn_project.tscn")

@onready var camera: Camera2D = $Workspace/Camera2D


func _enter_tree() -> void:
	GNp.editor = self


func _ready() -> void:
	var project = GNpProject.new()
	GNp.load_project(project)
