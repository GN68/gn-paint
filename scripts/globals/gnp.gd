extends Node
## Main hub for manipulating the editor

const FILE_EXTENSION = "gnp"

const EDITOR = preload("res://editor.tscn")

var current_editor: GNpEditor
var editors: Array[GNpEditor] = [] ## Holds all instances of editors
var root: GNpEditorRoot ## Pointer to the root of the program, the one that holds all editors

signal editor_changed(editor: GNpEditor)
signal editor_added(index: int, editor: GNpEditor)
signal editor_removed(index: int, editor: GNpEditor)


## Creates a new editor using the given project
func new_editor(project: GNpProject):
	var new_editor:GNpEditor = EDITOR.instantiate()
	var id = editors.size()
	editors.append(new_editor)
	root.parent_editor(new_editor)
	new_editor.setup(project)
	editor_added.emit(id,new_editor)
	set_focused_editor(new_editor)


## Force closes an editor
func close_editor(editor: GNpEditor):
	for i in range(editors.size()):
		var e = editors[i]
		if e == editor:
			editor.queue_free()
			editor_removed.emit(i,editor)


## Returns the editor the given node belongs to
func get_editor(node: Node) -> GNpEditor:
	for editor in editors:
		if editor.is_ancestor_of(node):
			return editor
	push_error("No editor found related to given node: ",node)
	return null

func set_focused_editor(editor: GNpEditor):
	if editors.has(editor):
		for e in editors:
			e.set_active(e == editor)
		if editor != current_editor:
			current_editor = editor
			editor_changed.emit(editors)

# TODO: implement fully 
func thumbnail_project(path):
	# https://specifications.freedesktop.org/thumbnail/latest-single/
	var to_hash_path = str("file://",path)
	
	var ctx = HashingContext.new()
	ctx.start(HashingContext.HASH_MD5)
	ctx.update(to_hash_path.to_ascii_buffer())
	var res = ctx.finish().hex_encode()
