extends Resource
class_name GNpLayer

@export var project: GNpProject
@export var texture: DrawableTexture2D
@export var name: String = "Unnamed Layer"
@export var blend_mode: CanvasItemMaterial.BlendMode = CanvasItemMaterial.BLEND_MODE_MIX
@export var visible:bool = true

var layer_index: int = 0
@export_storage var id: int ## used to identify
const BLIT_REPLACE = preload("uid://dcfegpdevxvn5")
const BLIT_ALPHA_OVER = preload("uid://bnmdd7xvn7t7n")
const BLIT_REPLACE_PREMUL = preload("uid://burv0332r4goy")

var workspace: GNpLayerRenderer

signal visibility_changed(visible: bool)


func _init(source_project: GNpProject,color: Color = Color.WHITE) -> void:
	project = source_project
	var resolution = project.resolution
	texture = DrawableTexture2D.new()
	texture.setup(resolution.x,resolution.y,project.format,color,true)


func replace_image(image: Image,offset: Vector2i = Vector2i.ZERO):
	var tex = ImageTexture.create_from_image(image)
	texture.blit_rect(Rect2i(offset,image.get_size()),tex,Color.WHITE,0,BLIT_REPLACE)
	texture.generate_mipmaps()


## Overlays the given image onto the layer with the alpha over operation
func overlay_image(image: Image,offset: Vector2i = Vector2i.ZERO):
	var tex = ImageTexture.create_from_image(image)
	texture.blit_rect(Rect2i(offset,image.get_size()),tex,Color.WHITE,0,BLIT_REPLACE_PREMUL)
	texture.generate_mipmaps()


func set_visible(new_visible: bool):
	if visible != new_visible:
		visible = new_visible
		visibility_changed.emit(visible)

func remove_layer():
	project.layer_remove(self)
