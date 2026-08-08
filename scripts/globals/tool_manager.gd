extends Node
## Holds the registry and input handling of tools for the canvas

var tools: Array[GNpTool] = []
var active_tool: GNpTool


signal load_tools ## Called before tools are loaded, hook up to this event and add child the custom tools
signal active_tool_changed(tool: GNpTool,last_tool: GNpTool) ## Called when the tool being used changes
signal tools_loaded ## Called when all tools has been loaded

func _ready() -> void:
	load_tools.emit()
	for child in get_children():
		if child is GNpTool:
			register_tool(child)
	tools_loaded.emit()

## Registers the given tool to the.. registry
func register_tool(tool: GNpTool):
	tools.append(tool)


## Sets the active tool being used by the user
func set_active_tool(tool: GNpTool):
	if tool != active_tool and tools.has(tool):
		var last_tool = active_tool
		active_tool = tool
		active_tool_changed.emit(active_tool,last_tool)
