extends MarginContainer

func _ready() -> void:
	GNpToolManager.active_tool_changed.connect(_on_active_tool_changed)

var active_tool_options: Control

func _on_active_tool_changed(tool: GNpTool,last_tool: GNpTool):
	if last_tool:
		if last_tool.toolbar:
			last_tool.toolbar.reparent(last_tool)
			last_tool.toolbar.visible = false
	
	if tool:
		if tool.toolbar:
			tool.toolbar.reparent(self)
			tool.toolbar.visible = true
