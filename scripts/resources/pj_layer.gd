extends Resource
class_name GNpLayer

@export var project: GNpProject
@export var texture: DrawableTexture2D
@export var name: String
@export var blend_mode: CanvasItemMaterial.BlendMode = CanvasItemMaterial.BLEND_MODE_MIX
@export_storage var id: int ## used to identify
const BLIT_REPLACE = preload("uid://dcfegpdevxvn5")


func _init(project: GNpProject,color: Color = Color.WHITE) -> void:
	var resolution = project.resolution
	texture = DrawableTexture2D.new()
	texture.setup(resolution.x,resolution.y,project.format,color,false)

func load_image(image: Image):
	var tex = ImageTexture.create_from_image(image)
	texture.blit_rect(Rect2i(Vector2i.ZERO,image.get_size()),tex,Color.WHITE,0,BLIT_REPLACE)
