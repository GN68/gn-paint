extends GNpTool

const CIRCLE = preload("uid://cmrabdk0drumm")

@export var heads: Array[GNpBrushHead] = [CIRCLE]
@onready var preview: Node2D = $Canvas/Brush
@onready var preview_sprite: Sprite2D = $Canvas/Brush/Preview

const STEP_SIZE = 0.1
const HALF: Vector2 = Vector2(0.5,0.5)

var brush_size: int = 16
var head: GNpBrushHead
var _sprite_width: int = 1 # cached to avoid checking the image width when changing brush size
var brush_target: Vector2
var brush_pos: Vector2



signal brush_size_changed(size: int)
signal brush_head_changed(head: GNpBrushHead,last_head: GNpBrushHead)

func _ready() -> void:
	super()
	set_brush_head(heads[0])


func process_brush(start: bool = false):
	if not workspace: return
	if not workspace.has_proposal(): return
	var mouse_pos = preview.get_global_mouse_position()
	brush_target = mouse_pos
	
	if start:
		brush_pos = brush_target
	
	var vec_size = Vector2(brush_size,brush_size)
	var step_size = STEP_SIZE * brush_size
	var step_count: int
	if start:
		step_count = 1
	else:
		step_count = brush_pos.distance_to(brush_target) / step_size
	for step in range(step_count):
		brush_pos += (brush_target-brush_pos).normalized() * step_size
		head.shader.set_shader_parameter("resolution",brush_size)
		workspace.proposal_canvas.texture.blit_rect(Rect2i(brush_pos - vec_size / 2 + HALF,vec_size),null,GNp.color_primary,0,head.shader)

func _canvas_input(event: InputEvent) -> void:
	if event == null:
		preview.visible = false
	else:
		preview.visible = true

func _tool_process(delta: float) -> void:
	preview.position = preview.get_global_mouse_position()
	if Input.is_action_just_pressed("primary"):
		workspace = GNp.active_project.active_layer.workspace
		workspace.request_proposal()
		process_brush(true)
	if Input.is_action_pressed("primary"):
		process_brush()
	if Input.is_action_just_released("primary"):
		if workspace:
			workspace.confirm_proposal()
		pass

func set_brush_head(selected_head: GNpBrushHead):
	if head != selected_head:
		var last_head = head
		head = selected_head
		brush_head_changed.emit(last_head,head)
		_sprite_width = head.preview.get_width()
		preview_sprite.texture = head.preview
		update_brush_size()

func set_brush_size(px: int):
	if brush_size != px:
		brush_size = px
	update_brush_size()


func update_brush_size():
	
	preview.scale.x = float(brush_size) / float(_sprite_width)
	preview.scale.y = preview.scale.x
	brush_size_changed.emit(brush_size)


func _on_brush_size_spin_box_value_changed(value: float) -> void:
	set_brush_size(value)
