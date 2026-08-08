extends OptionButton



func _ready() -> void:
	for tool in GNpToolManager.tools:
		add_icon_item(tool.tool_icon,tool.tool_name)
	GNpToolManager.active_tool_changed.connect(_on_active_tool_changed)
	item_selected.connect(_on_item_selected)

func _on_active_tool_changed(tool: GNpTool, last_tool: GNpTool):
	select(tool.get_index())

func _on_item_selected(index: int):
	GNpToolManager.set_active_tool(GNpToolManager.tools[index])
