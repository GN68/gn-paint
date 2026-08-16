extends HBoxContainer


const TOOLBAR_BUTTON = preload("uid://my6cxow4fawc")


func _ready() -> void:
	var count = GNpToolManager.tools.size()-1
	for i in range(count+1):
		var tool = GNpToolManager.tools[i]
		var btn: Button = TOOLBAR_BUTTON.instantiate()
		btn.icon = tool.tool_icon
		match i:
			0: btn.theme_type_variation = "ButtonLeft"
			count: btn.theme_type_variation = "ButtonRight"
			_: btn.theme_type_variation = "ButtonHorizontal"
		add_child(btn)
		var tool_setter = func():
			GNpToolManager.set_active_tool(tool)
		btn.pressed.connect(tool_setter)
