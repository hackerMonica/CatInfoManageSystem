extends TabContainer
var userIcon
var catPageIcon

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func _init():
#	userIcon = Texture.new()
#	userIcon = load("res://icons/Line_version/Icon_user.png")
#	catPageIcon = load("res://icons/Line_version/Icon_home.png")
	pass
# Called when the node enters the scene tree for the first time.
func _ready():
#	set_tab_icon(0,userIcon)
#	set_tab_icon(1,catPageIcon)
	get_tree().root.set_transparent_background(true)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
