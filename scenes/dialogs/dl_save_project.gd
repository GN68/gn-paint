extends FileDialog
class_name GNpSaveProjectDialog

var project: GNpProject

func setup(target_project: GNpProject):
	project = target_project
	popup_centered()

func _on_file_selected(path: String) -> void:
	if !path.ends_with(GNp.FILE_EXTENSION):
		path = path.get_basename()+"."+GNp.FILE_EXTENSION
	project.save_to_file(path)

func _on_close_requested() -> void:
	queue_free()
