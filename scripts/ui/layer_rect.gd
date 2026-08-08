extends TextureRect
class_name LayerRect

@export var layer: GNpLayer

func _init() -> void:
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST_WITH_MIPMAPS
