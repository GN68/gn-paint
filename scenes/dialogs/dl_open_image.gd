extends FileDialog
class_name GNpOpenImageDialog

func setup():
	popup_centered()

func _on_file_selected(path: String) -> void:
	var file = FileAccess.open(path,FileAccess.READ)
	var buffer = file.get_buffer(file.get_length())
	print(path)
	print("len start ",file.get_length())
	
	var image: Image = Image.new()
	var err: Error
	match path.get_extension():
		"gnp":
			pass # TODO: Load project file
		_:
			image = Image.load_from_file(path)
			print(image.get_size())
	var project = GNpProject.create_from_image(image,path)
	GNp.load_project(project)

func _on_close_requested() -> void:
	queue_free()
