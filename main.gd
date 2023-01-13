extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var loginPage_scene = preload("res://login/Login.tscn")
var loginPage
var sininPage_scene = preload("res://signinPage/SigninPage.tscn")
var sininPage
var mainPage_scene = preload("res://mainPage/MainPage.tscn")
var mainPage

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalVar.connect("backend_login_callback",self,"_on_backend_login_callback")
	GlobalVar.connect("backend_signup_callback",self,"_on_backend_signup_callback")
	GlobalVar.connect("backend_auto_login_callback",self,"_on_backend_auto_login_callback")
	
	var config = ConfigFile.new()
	var err = config.load("user://user_account.save")
	if err == OK:
		GlobalVar.account = config.get_value("user_account","account",GlobalVar.account)
		GlobalVar.passWord = config.get_value("user_account","password",GlobalVar.passWord)
		print(GlobalVar.account+"\t"+GlobalVar.passWord)
		if GlobalVar.account!=null && GlobalVar.account != "":
			GlobalVar.backend_auto_login()
			return
	loginPage = loginPage_scene.instance()
	add_child(loginPage)
	loginPage.connect("signinAccount",self,"_on_signinAccount")

func _on_backend_signup_callback(message:bool):
	if message:
		$U_AcceptDialog.window_title="注册成功"
		$U_AcceptDialog.dialog_text="您申请的账号注册成功！"
		u_popup()
	else:
		$U_AcceptDialog.window_title="出错"
		$U_AcceptDialog.dialog_text="您申请的账号已存在或注册出错，请重试"
		u_popup()

func _on_backend_login_callback(message,errorCode:int):
	if errorCode==1:
		print("account don't exist\n")
		$U_AcceptDialog.window_title="出错"
		$U_AcceptDialog.dialog_text="您的账号不存在，请检查账号或申请注册"
		u_popup()
	elif message == true:
		print("login successful\n")
		$U_AcceptDialog.window_title="成功"
		$U_AcceptDialog.dialog_text="登陆成功！"
		u_popup()
		GlobalVar.is_login=true
	elif message == false:
		print("login failed\n")
		$U_AcceptDialog.window_title="出错"
		$U_AcceptDialog.dialog_text="您的密码出错，请检查密码并重新输入"
		u_popup()
	else:
		push_error("unexpected status!\n")
func _on_backend_auto_login_callback(message):
	if message:
		mainPage = mainPage_scene.instance()
		add_child(mainPage)
		mainPage.connect("logout",self,"_on_logout")
	else:
		loginPage = loginPage_scene.instance()
		add_child(loginPage)
		loginPage.connect("signinAccount",self,"_on_signinAccount")
	pass

func _on_signinAccount():
	sininPage = sininPage_scene.instance()
	remove_child(loginPage)
	loginPage.queue_free()
	add_child(sininPage)
	sininPage.connect("signinBack",self,"_on_signinBack")

func _on_signinBack():
	remove_child(sininPage)
	sininPage.queue_free()
	loginPage = loginPage_scene.instance()
	add_child(loginPage)
	loginPage.connect("signinAccount",self,"_on_signinAccount")

func u_popup():
	var screen_size = get_viewport().get_visible_rect().size
	$U_AcceptDialog.popup_centered(Vector2(screen_size.x/4,screen_size.y/4))
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_U_AcceptDialog_popup_hide():
	if GlobalVar.is_login==false:
		return
	mainPage = mainPage_scene.instance()
	remove_child(loginPage)
	loginPage.queue_free()
	add_child(mainPage)
	mainPage.connect("logout",self,"_on_logout")
func _on_logout():
	remove_child(mainPage)
	mainPage.queue_free()
	loginPage = loginPage_scene.instance()
	add_child(loginPage)
	loginPage.connect("signinAccount",self,"_on_signinAccount")
	GlobalVar.is_login =false
	pass
# clear all children
# func clear_children():
# 	var children = get_children()
# 	for child in children:
# 		remove_child(child)
# 		child.queue_free()
