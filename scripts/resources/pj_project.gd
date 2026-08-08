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


signal layer_added(index: int,layer: GNpLayer)
signal layer_removed(index: int)


func _init(width: int = 480, height: int = 360,background_color: Color = Color.WHITE):
	resolution = Vector2i(width,height)
	new_layer(0,background_color)

static func create_from_image(image: Image,source: String):
	var project = GNpProject.new(image.get_width(),image.get_height())
	project.name = source.get_file()
	project.source = source
	project.get_layer(0).load_image(image)
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
	elif index == layers.size():
		layers.append(layer)
		layer_added.emit(index,layer)


## Adds the given [GNpLayer] to the project
func layer_add(layer: GNpLayer):
	var index = layers.size()
	layers.append(layer)
	layer_added.emit(index)


## Removes the given [GNpLayer] to the project
func layer_remove(index: int):
	if layers.has(index):
		layers.remove_at(index)
		layer_removed.emit(index)


## removes the layer with the given id,
## Note that this removes the layer with its unique ID, not the project layer ID
func layer_remove_by_id(layer_id: int):
	var i = 0
	for layer in layers:
		if layer.id == layer_id:
			layers.remove_at(i)
			layer_removed.emit()
			return
		i += 1

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
