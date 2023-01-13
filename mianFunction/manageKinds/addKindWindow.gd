extends AcceptDialog
signal addEnter(name)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	resize()
	pass # Replace with function body.

func resize():
	$"%LineEdit".set_size(Vector2(300,80))
	var size = $"%LineEdit".get_rect().size
	var screen_size = get_parent_area_size()
	$"%LineEdit".set_position(Vector2((screen_size-size)/2))

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_AddDialog_confirmed():
	var text = $"%LineEdit".text
	if text !="":
		emit_signal("addEnter",text)
