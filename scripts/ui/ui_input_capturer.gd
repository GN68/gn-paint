extends Button

signal canvas_input(event: InputEvent)

var allow = false

func _gui_input(event: InputEvent) -> void:
	if allow:
				GNpToolManager.canvas_input(event)
				canvas_input.emit(event)
				accept_event()

func _process(delta: float) -> void:
	allow = (get_viewport().gui_get_focus_owner() == self)
	if allow:
		GNpToolManager.tool_process(delta)

func _on_mouse_entered() -> void:
	grab_focus()


func _on_mouse_exited() -> void:
	GNpToolManager.canvas_input(null)
