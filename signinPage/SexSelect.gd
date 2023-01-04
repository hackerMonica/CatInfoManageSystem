extends MenuButton
var id=-1

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var popup = get_popup()
	popup.connect("id_pressed",self,"_on_id_pressed")
	pass # Replace with function body.

func _on_id_pressed(id:int):
	if(id==0):
		text="女"
		id=0
	elif(id==1):
		text="男"
		id=1
	else:
		push_error("get wrong id from popup!\n")
func get_id():
	return id
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
