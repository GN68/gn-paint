extends VBoxContainer


const TOOLBAR_BUTTON = preload("uid://my6cxow4fawc")


func _ready() -> void:
	for tool in GNpToolManager.tools:
		var btn: Button = TOOLBAR_BUTTON.instantiate()
		btn.icon = tool.tool_icon
		add_child(btn)
		var tool_setter = func():
			GNpToolManager.set_active_tool(tool)
		btn.pressed.connect(tool_setter)
