extends Node2D

func _ready() -> void:
	GNpToolManager.active_tool_changed.connect(_on_active_tool_changed)


func _on_active_tool_changed(tool: GNpTool,last_tool: GNpTool):
	if last_tool:
		if last_tool.overlay:
			last_tool.overlay.reparent(last_tool)
			last_tool.overlay.visible = false
	
	if tool:
		if tool.overlay:
			tool.overlay.reparent(self)
			tool.overlay.visible = true
