extends Button

var project: GNpProject

func _on_pressed() -> void:
	GNp.set_active_project(project)
