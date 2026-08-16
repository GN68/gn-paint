extends HBoxContainer

const UI_BTN_PROJECT = preload("res://scenes/buttons/ui_btn_project.tscn")

func _ready() -> void:
	GNp.project_added.connect(_on_project_added)
	GNp.project_removed.connect(_on_project_removed)
	rebuild_project_buttons()


func _on_project_added(index: int, project: GNpProject):
	rebuild_project_buttons()


func _on_project_removed(index: int, project: GNpProject):
	rebuild_project_buttons()


func rebuild_project_buttons():
	for child in get_children():
		child.queue_free()
	
	for project in GNp.projects:
		var btn:Button = UI_BTN_PROJECT.instantiate()
		btn.text = project.name
		btn.project = project
		add_child(btn)
