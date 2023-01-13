extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var default_cursor = preload("res://icons/default.png")
var pithing_cursor = preload("res://icons/pitch.png")
var ibeam_cursor   = preload("res://icons/fishbone.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_custom_mouse_cursor(default_cursor,Input.CURSOR_ARROW,Vector2(1,3))
	Input.set_custom_mouse_cursor(ibeam_cursor,Input.CURSOR_IBEAM,Vector2(9,15))
	Input.set_custom_mouse_cursor(pithing_cursor,Input.CURSOR_POINTING_HAND,Vector2(9,0))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



# change cursor shape when selecting something
func selecting():
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
# recover cursor shape when unselect something
func unSelecting():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
