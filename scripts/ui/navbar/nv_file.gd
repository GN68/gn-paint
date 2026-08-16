extends Button

const DIALOG_NEW_IMAGE = preload("res://scenes/dialogs/dl_new_image.tscn")
const DIALOG_SAVE_PROJECT = preload("res://scenes/dialogs/dl_save_project.tscn")
const DL_OPEN_IMAGE = preload("res://scenes/dialogs/dl_open_image.tscn")

@onready var popup: PopupMenu = get_child(0)

func _on_pressed() -> void:
	popup.popup(Rect2(global_position + Vector2(0,size.y),Vector2.ZERO))


func _on_popup_menu_id_pressed(id: int) -> void:
	match id:
		0: _new_image()
		1: _open_image()
		2: _save_image()
		3: _save_as_image()

func _new_image():
	var dialog: ConfirmationDialog = DIALOG_NEW_IMAGE.instantiate()
	get_tree().current_scene.add_child(dialog)
	dialog.popup_centered()
	pass

func _open_image():
	var dialog: GNpOpenImageDialog = DL_OPEN_IMAGE.instantiate()
	get_tree().current_scene.add_child(dialog)
	dialog.setup()


func _save_image():
	var dialog: GNpSaveProjectDialog = DIALOG_SAVE_PROJECT.instantiate()
	get_tree().current_scene.add_child(dialog)
	dialog.setup(GNp.active_project)

func _save_as_image():
	pass
