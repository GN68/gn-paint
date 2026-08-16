extends Button
class_name GNpUILayerButton

var layer: GNpLayer

@onready var edit_button: Button = $EditButton
@onready var visibility_button: Button = $VisibilityButton
@onready var preview_texture_rect: TextureRect = $MarginContainer/PreviewTextureRect
@onready var layer_name_edit: LineEdit = $LayerNameEdit

func set_layer(new_layer: GNpLayer):
	
	layer_name_edit.text = new_layer.name
	layer_name_edit.placeholder_text = "Unnamed Layer"
	preview_texture_rect.texture = new_layer.texture
	_on_visibility_button_toggled(not new_layer.visible)

const ICON_VISIBLE = preload("uid://ck3bgpnph47m6")
const ICON_INVISIBLE = preload("uid://dyoaf06ac27oh")


func _on_visibility_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		visibility_button.icon = ICON_INVISIBLE
	else:
		visibility_button.icon = ICON_VISIBLE
	if layer:
		layer.set_visible(toggled_on)

# button.theme_type_variation = &"ButtonHighlighted"
