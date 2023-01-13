extends Control
signal signinConfirm
signal signinBack
# Declare member variables here. Examples:
var mess_y=0.15
var grid_y=0.5
var but_y=0.85
var account
var passWord
var passWord2
var username
var sex


# Called when the node enters the scene tree for the first time.
func _ready():
	resize()
	var dynamic_font = DynamicFont.new()
	dynamic_font.font_data = load("res://MiSans/MiSans-Normal.ttf")
	dynamic_font.size = 25
	var popup = $EnterField/Sex/SexSelect.get_popup()
	popup.add_font_override("font",dynamic_font)
	$U_ConfirmDialog.add_font_override("font2",dynamic_font)

func resize():
	var screen_size = get_viewport().get_visible_rect().size
	$Buttons.set_size(Vector2(screen_size.x*0.618,60))
	$EnterField.set_size(Vector2(screen_size.x*0.7,60))
	$Buttons.set_position(Vector2((screen_size.x-$Buttons.get_rect().size.x)/2,but_y*screen_size.y-$Buttons.get_rect().size.y/2))
	$EnterField.set_position(Vector2((screen_size.x-$EnterField.get_rect().size.x)/2,grid_y*screen_size.y-$EnterField.get_rect().size.y/2))
	$Message.set_position(Vector2((screen_size.x-$Message.get_rect().size.x)/2, mess_y*screen_size.y-$Message.get_rect().size.y/2))
	$EnterField/Account.add_constant_override("separation",0.1*screen_size.x)
	$EnterField/Pass.add_constant_override("separation",0.1*screen_size.x)
	$EnterField/Pass2.add_constant_override("separation",0.1*screen_size.x)
	$EnterField/Name.add_constant_override("separation",0.1*screen_size.x)
	$EnterField/Sex.add_constant_override("separation",0.1*screen_size.x)
	$EnterField/Description.add_constant_override("separation",0.1*screen_size.x)
	$EnterField.add_constant_override("separation",0.015*screen_size.y)

func backend_callback(message: String):
	if message == "passed":
		emit_signal("signinConfirm")
	elif message == "denied":
		print("Login failed")
	else:
		print("ERROR: unexpected")

func _on_ConfirmButton_pressed():
	account = $EnterField/Account/UserAccount.text
	passWord = $EnterField/Pass/PassWord.text.sha256_text()
	passWord2 = $EnterField/Pass2/PassWord.text.sha256_text()
	username = $EnterField/Name/UserName.text
	sex = $EnterField/Sex/SexSelect.get_id()
	if(!(checkNull()&&checkPassWord())):
		return
	GlobalVar.account = account
	GlobalVar.passWord = passWord
	GlobalVar.username = username
	GlobalVar.sex      = sex
	GlobalVar.description = $EnterField/Description/Label.text
	GlobalVar.backend_signup()
#	emit_signal("signinConfirm")


func _on_BackButton_pressed():
	emit_signal("signinBack")


func _on_SigninPage_resized():
	resize()

func checkNull():
	$U_ConfirmDialog.window_title="出错"
	if account == "":
		$U_ConfirmDialog.dialog_text="账号为空，请输入账号！"
		u_popup()
		return false
	if (passWord==""||passWord2==""):
		$U_ConfirmDialog.dialog_text="密码为空，请输入密码！"
		u_popup()
		return false
	if username == "":
		$U_ConfirmDialog.dialog_text="昵称为空，请输入昵称！"
		u_popup()
		return false
	if sex == -1:
		$U_ConfirmDialog.dialog_text="性别尚未选择，请选择性别！"
		u_popup()
		return false
	return true

func checkPassWord():
	if(passWord!=passWord2):
		$U_ConfirmDialog.window_title="出错！"
		$U_ConfirmDialog.dialog_text="您两次输入的密码不同，请重新输入！"
		u_popup()
		return false
	else:
		return true

func u_popup():
	var screen_size = get_viewport().get_visible_rect().size
	$U_ConfirmDialog.popup_centered(Vector2(screen_size.x/4,screen_size.y/4))
