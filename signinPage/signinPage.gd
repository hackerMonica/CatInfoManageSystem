extends Control
signal signinConfirm
signal signinBack
# Declare member variables here. Examples:
var mess_y=0.25
var grid_y=0.5
var but_y=0.8


# Called when the node enters the scene tree for the first time.
func _ready():
	resize()

func resize():
	var screen_size = get_viewport().get_visible_rect().size
	$Buttons.set_size(Vector2(screen_size.x*0.618,60))
	$EnterField.set_size(Vector2(screen_size.x*0.7,60))
	$Buttons.set_position(Vector2((screen_size.x-$Buttons.get_rect().size.x)/2,but_y*screen_size.y-$Buttons.get_rect().size.y/2))
	$EnterField.set_position(Vector2((screen_size.x-$EnterField.get_rect().size.x)/2,grid_y*screen_size.y-$EnterField.get_rect().size.y/2))
	$Message.set_position(Vector2((screen_size.x-$Message.get_rect().size.x)/2, mess_y*screen_size.y-$Message.get_rect().size.y/2))
	$EnterField/User.add_constant_override("separation",0.1*screen_size.x)
	$EnterField/Pass.add_constant_override("separation",0.1*screen_size.x)
	$EnterField.add_constant_override("separation",0.06*screen_size.y)

func backend_callback(message: String):
	if message == "passed":
		emit_signal("signinConfirm")
	elif message == "denied":
		print("Login failed")
	else:
		print("ERROR: unexpected")

func _on_ConfirmButton_pressed():
	GlobalVar.userName = $EnterField/User/UserName.text
	GlobalVar.passWord = $EnterField/Pass/PassWord.text
	GlobalVar.backend_signup()
#	emit_signal("signinConfirm")


func _on_BackButton_pressed():
	emit_signal("signinBack")


func _on_SigninPage_resized():
	resize()
