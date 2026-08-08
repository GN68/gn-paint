extends Button

var editor: GNpEditor

func _on_pressed() -> void:
	GNp.set_focused_editor(editor)
