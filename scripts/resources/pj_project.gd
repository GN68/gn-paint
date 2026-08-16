extends Resource
class_name GNpProject

const FILE_EXTENSION = ".gnp"

@export var name: String = "Unnamed Project"
@export var source: String ## Path to the source of the image
@export var layers: Array[GNpLayer]
@export var resolution: Vector2i = Vector2i(480,360)
@export var format: DrawableTexture2D.DrawableFormat = DrawableTexture2D.DRAWABLE_FORMAT_RGBA8

@export_category("Project Status")
@export var edited: bool = false
@export var history: Array[Image]
@export var version: int = 0

@export_category("Editor")
@export var active_layer: GNpLayer
#@export var camera_pos: Vector2
#@export var camera_zoom: float

signal layer_added(index: int,layer: GNpLayer)
signal layer_removed(index: int)
signal active_layer_changed(index: int)


func _init(width: int = 480, height: int = 360,background_color: Color = Color.WHITE):
	resolution = Vector2i(width,height)
	new_layer(0,background_color)
	active_layer = layers[0]

static func create_from_image(image: Image,source: String):
	var project = GNpProject.new(image.get_width(),image.get_height())
	project.name = source.get_file()
	project.source = source
	project.get_layer(0).replace_image(image)
	return project

func get_layer(index: int):
	return layers[index]

## Creates a new blank [GNpLayer] to the project
func new_layer(index: int = -1,color: Color = Color.TRANSPARENT):
	if index == -1:
		index = layers.size()
	var layer = GNpLayer.new(self,color)
	layer_add(layer)


## Sets the given project layer index to the given [GNpLayer]
func layer_set(index: int, layer: GNpLayer):
	if index < layers.size(): # replacing an existing layer
		layer_removed.emit(index)
		layers.set(index,layer)
		layer_added.emit(index,layer)
		layer.layer_index = index
	elif index == layers.size():
		layers.append(layer)
		layer_added.emit(index,layer)
		layer.layer_index = index


## Adds the given [GNpLayer] to the project
func layer_add(layer: GNpLayer):
	var index = layers.size()
	layers.append(layer)
	layer.layer_index = index
	layer_added.emit(index)


## Removes the given [GNpLayer] to the project
func layer_remove(layer: GNpLayer):
	if layers.has(layer):
		layers.erase(layer)
		layer_removed.emit(layer.layer_index)


## removes the layer with the given id,
## Note that this removes the layer with its unique ID, not the project layer ID
func layer_remove_by_index(index: int):
	if index <= 0 and index > layers.size():
		layers.remove_at(index)
		layer_removed.emit(index)


## TODO: implement
func select_layer_by_index(index: int):
	index = clampi(index,0,layers.size()-1)
	pass

func select_layer(layer: GNpLayer):
	if layers.has(layer):
		if layer != active_layer:
			var last_active_layer := active_layer
			active_layer = layer
			active_layer_changed.emit(layer,last_active_layer)


#TODO: IMPLEMENT METHOD
func marge_layers(layer1: GNpLayer,layer2: GNpLayer):
	var workspace = layer1.workspace
	workspace.request_proposal()
	var ogParent = layer2.workspace.get_parent()
	layer2.workspace.reparent(workspace.overlay)
	
	await RenderingServer.frame_post_draw
	workspace.confirm_proposal()
	
	await RenderingServer.frame_post_draw
	layer2.workspace.reparent(ogParent)
	layer2.remove_layer()


## Packs the project file into a buffer
#TODO: replace with a strict method
func pack_to_buffer():
	var buffer: PackedByteArray = var_to_bytes_with_objects(self)
	return buffer

static func unpack_from_buffer(buffer: PackedByteArray):
	var project = bytes_to_var_with_objects(buffer)
	#TODO: test if this returns a project object variant
	print(project)
	return project

func save_to_file(path: String):
	if path.ends_with(FILE_EXTENSION):
		var buffer = pack_to_buffer()
		var file = FileAccess.open(path,FileAccess.WRITE)
		file.store_buffer(buffer)
		file.close()
		
		var err = file.get_open_error()
		print("Saved project file with err: ",err)
	else:
		push_error(str("Invalid file extension, expected ",FILE_EXTENSION))

static func load_from_file(path: String):
	if path.ends_with(FILE_EXTENSION):
		var file = FileAccess.open(path,FileAccess.READ)
		var buffer: PackedByteArray = file.get_buffer(file.get_length())
		return unpack_from_buffer(buffer)
	else:
		push_error(str("Invalid file extension, expected ",FILE_EXTENSION))
