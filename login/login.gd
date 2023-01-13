extends Control
signal confirmAccount
signal signinAccount
#y-ratio
var mess_y=0.25
var grid_y=0.5
var but_y=0.8
var account
var passWord

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
#func _process(delta):
#	resize()


func login_callback(message: String):
	if message == "passed":
		emit_signal("confirmAccount")
	elif message == "denied":
		print("Login failed")
	else:
		print("ERROR: unexpected")


func _on_ConfirmButton_pressed():
	account = $EnterField/User/UserAccount.text
	passWord = $EnterField/Pass/PassWord.text.sha256_text()
	if(!checkNull()):
		return
	GlobalVar.account = account
	GlobalVar.passWord = passWord
	GlobalVar.backend_login()
	
func checkNull():
	$U_ConfirmDialog.window_title="出错"
	if account == "":
		$U_ConfirmDialog.dialog_text="账号为空，请输入账号！"
		u_popup()
		return false
	if (passWord==""):
		$U_ConfirmDialog.dialog_text="密码为空，请输入密码！"
		u_popup()
		return false
	return true

func u_popup():
	var screen_size = get_viewport().get_visible_rect().size
	$U_ConfirmDialog.popup_centered(Vector2(screen_size.x/4,screen_size.y/4))

func _on_SigninButton_pressed():
	emit_signal("signinAccount")

func _on_Login_resized():
	resize()
