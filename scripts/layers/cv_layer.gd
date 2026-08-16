extends Sprite2D
class_name GNpLayerRenderer

## The node that renders the overlay onto the canvas, nothing useful for developers here
@onready var preview_overlay: SubViewportContainer = $PreviewOverlay

## The renderer and base node to append nodes to paste onto the canvas
@onready var overlay: SubViewport = $PreviewOverlay/SubViewport

## a temporary canvas to draw from before being submitted to the real project
@onready var proposal_canvas: Sprite2D = $PreviewOverlay/SubViewport/ProposalCanvas

const BACKDROP_SETUP = preload("uid://bhjkvfhibwrpb")

@onready var proposal_backdrop: Sprite2D = $PreviewOverlay/SubViewport/ProposalBackdrop
@onready var debug_display: Sprite2D = $debugDisplay

var proposal_enabled = false

var layer: GNpLayer

## Assembles the layer using the given data
func setup(new_layer: GNpLayer):
	layer = new_layer
	
	texture = layer.texture
	var resolution: Vector2i = layer.project.resolution
	overlay.size = resolution
	layer.workspace = self

func has_proposal() -> bool:
	return proposal_enabled


## Requests a canvas proposal for the tools to mess around with
func request_proposal():
	if !proposal_enabled:
		var tex = DrawableTexture2D.new()
		var res = layer.project.resolution
		tex.setup(res.x,res.y,DrawableTexture2D.DRAWABLE_FORMAT_RGBA8,Color(0,0,0,0))
		tex.blit_rect(Rect2i(Vector2i.ZERO,texture.get_size()),texture,Color.WHITE,0,BACKDROP_SETUP)
		proposal_canvas.texture = tex
		preview_overlay.visible = true
		overlay.render_target_update_mode = SubViewport.UPDATE_ALWAYS
		proposal_enabled = true


## Applies the proposal onto the canvas
## NOTE: this is asnyc
func confirm_proposal():
	if proposal_enabled:
		proposal_enabled = false
		await RenderingServer.frame_post_draw 
		var image_check = overlay.get_texture().get_image()
		var rect = image_check.get_used_rect()
		
		proposal_backdrop.texture = texture
		await RenderingServer.frame_post_draw
		
		var image_final = overlay.get_texture().get_image().get_region(rect)
		layer.overlay_image(image_final,rect.position)
		preview_overlay.visible = false
		debug_display.texture = overlay.get_texture()
		proposal_canvas.texture = null
		overlay.render_target_update_mode = SubViewport.UPDATE_DISABLED
		proposal_backdrop.texture = null
