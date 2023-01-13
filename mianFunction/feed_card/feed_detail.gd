extends AcceptDialog


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_value(value:Array):
	$VBoxContainer/user_name/Label2.text = value[0]
	$VBoxContainer/cat_name/Label2.text = value[1]
	$VBoxContainer/feed_date/Label2.text = value[2]
	$VBoxContainer/place_name/Label2.text = value[3]
	$VBoxContainer/feed_food/TextEdit.text = value[4]

func head(value:Array):
	$VBoxContainer/user_name/Label.text = value[0]
	$VBoxContainer/cat_name/Label.text = value[1]
	$VBoxContainer/feed_date/Label.text = value[2]
	$VBoxContainer/place_name/Label.text = value[3]
	$VBoxContainer/feed_food/Label.text = value[4]
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
