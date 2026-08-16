extends Node
## Main hub for manipulating the editor

const FILE_EXTENSION = "gnp"

var editor: GNpEditorRoot

var active_project: GNpProject
var projects: Array[GNpProject] = [] ## Holds all instances of editors

signal active_project_changed(project: GNpProject)
signal project_added(index: int, project: GNpProject)
signal project_removed(index: int, project: GNpProject)


func load_project(project: GNpProject, auto_active: bool = true):
	if !projects.has(project):
		projects.append(project)
		if auto_active:
			set_active_project(project)
			project_added.emit(projects.find(project),project)
	else:
		push_warning("Attempted to open an already opened project")

## Force closes an editor
func close_project(project: GNpEditor):
	if project.has(project):
		var id = projects.find(project)
		project.queue_free()
		project_removed.emit(id,project)
	else:
		push_warning("Attempted to close a project that wasnt loaded")


func set_active_project(project: GNpProject):
	if project != active_project:
		var last_project = active_project
		active_project = project
		active_project_changed.emit(active_project,last_project)

#================================================

var color_primary: Color = Color.BLACK : set = set_color_primary
var color_secondary: Color = Color.WHITE : set = set_color_secondary

## Emits 
signal color_changed(primary_color: Color, secondary_color: Color)

func swap_colors():
	var temp = color_secondary
	
	color_secondary = color_primary
	color_primary = temp


func set_color_primary(color: Color):
	if color_primary != color:
		color_primary = color
		color_changed.emit(color_primary,color_secondary)


func set_color_secondary(color: Color):
	if color_secondary != color:
		color_secondary = color
		color_changed.emit(color_primary,color_secondary)

#================================================
# TODO: implement fully 
func thumbnail_project(path):
	# https://specifications.freedesktop.org/thumbnail/latest-single/
	var to_hash_path = str("file://",path)
	
	var ctx = HashingContext.new()
	ctx.start(HashingContext.HASH_MD5)
	ctx.update(to_hash_path.to_ascii_buffer())
	var res = ctx.finish().hex_encode()
