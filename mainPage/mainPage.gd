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
var _client
func _ready():
	# get_tree().root.set_transparent_background(true)
	_client = HTTPRequest.new()
	add_child(_client)
	_client.connect("request_completed", self, "_on_data_received")
	get_user_info()
	var config = ConfigFile.new()
	config.set_value("user_account","account",GlobalVar.account)
	config.set_value("user_account","password",GlobalVar.passWord)
	config.save("user://user_account.save")
	self.set_current_tab(0)
	resize(0)
	resize(1)
	resize(2)
	resize(3)

func _on_data_received(_result, response_code, _headers, body):
	print(body.get_string_from_utf8()+"\n")
	if response_code!=200:
		push_error("server connection problem\n")
		return
	var json_return :JSONParseResult = JSON.parse(body.get_string_from_utf8())
	if(json_return.error!=OK):
		push_error(json_return.error_string)
		return
	var errorCode = json_return.result['error']
	if errorCode == 1:
		print("don't find account in database!\n")
		return
	var value = json_return.result['value'][0]
	GlobalVar.u_id = value['u_id']
	$"用户信息/InfoField/user_id/Label2".text = value['u_id']
	$"用户信息/InfoField/user_name/Label2".text = value['u_name']
	$"用户信息/InfoField/user_sex/Label2".text = "女"
	if value['u_sex']=="1":
		$"用户信息/InfoField/user_sex/Label2".text = "男"
	if value['u_description']==null:
		$"用户信息/user_description/Label2/TextEdit".text="您未填写补充信息"
	else :
		$"用户信息/user_description/Label2/TextEdit".text=value['u_description']
	pass

func send_message(fun,body):
	var headers = ["Content-Type: application/x-www-form-urlencoded","Content-Length:"+str(body.length())
	,"User-Agent: Pirulo/1.0 (Godot)","Accept: */*"]
	var error = _client.request(GlobalVar.http_url+fun,headers,false,HTTPClient.METHOD_POST, body)
	if error != OK:
		push_error("An error occurred in the HTTP request.")

func get_user_info():
	var info = GlobalVar.client.query_string_from_dict({"account": GlobalVar.account})
	send_message("get_user_info",info)

func resize(id:int):
	var screen_size = get_viewport().get_visible_rect().size
	screen_size.y -= $"用户信息".get_rect().position.y
	match id:
		0:
			$"用户信息/InfoField".set_position(Vector2(0,0.05*screen_size.y))
			$"用户信息/InfoField".add_constant_override("separation",0.05*screen_size.y)
			$"用户信息/user_description".set_position(
				Vector2(0.04*screen_size.x,screen_size.y*0.45))
			$"用户信息/user_description".add_constant_override("separation",0.08*screen_size.x)
			$"用户信息/user_description".set_size(
				Vector2(screen_size.x-0.08*screen_size.x,screen_size.y*0.4))
			var button_size = $"用户信息/ToolButton".get_rect().size
			$"用户信息/ToolButton".set_position(
				Vector2((screen_size.x-button_size.x)/2, screen_size.y*0.97-button_size.y))
			pass
		1:
			var allCatInfo_size = $"猫咪信息/allCatInfo".get_rect().size
			$"猫咪信息/allCatInfo".set_position(
				Vector2((screen_size.x/2-allCatInfo_size.x)*0.7, (screen_size.y-allCatInfo_size.y)/2))
			var searchCatInfo_size = $"猫咪信息/searchCatInfo".get_rect().size
			$"猫咪信息/searchCatInfo".set_position(
				Vector2(screen_size.x/2+(screen_size.x/2-searchCatInfo_size.x)*0.3, (screen_size.y-searchCatInfo_size.y)/2))
			pass
		2:
			var allCatInfo_size = $"打卡/feed_card".get_rect().size
			$"打卡/feed_card".set_position(
				Vector2((screen_size.x/2-allCatInfo_size.x)*0.6, (screen_size.y/2-allCatInfo_size.y)*0.6))
			var searchCatInfo_size = $"打卡/position_card".get_rect().size
			$"打卡/position_card".set_position(
				Vector2(screen_size.x/2+(screen_size.x/2-searchCatInfo_size.x)*0.4, (screen_size.y/2-searchCatInfo_size.y)*0.6))
			$"打卡/all_feed".set_position(
				Vector2((screen_size.x/2-allCatInfo_size.x)*0.6, screen_size.y/2+(screen_size.y/2-allCatInfo_size.y)*0.4))
			$"打卡/all_position".set_position(
				Vector2(screen_size.x/2+(screen_size.x/2-searchCatInfo_size.x)*0.4, screen_size.y/2+(screen_size.y/2-searchCatInfo_size.y)*0.4))
			var addFeed_size = $"打卡/addFeed_dialog".get_rect().size
			$"打卡/addFeed_dialog".set_position((screen_size-addFeed_size)/2)
			var addPlace_size = $"打卡/addPosition_dialog".get_rect().size
			$"打卡/addPosition_dialog".set_position((screen_size-addPlace_size)/2)
		3:
			var kindButton_size = $"维护/kind".get_rect().size
			var placeButton_size = $"维护/place".get_rect().size
			$"维护/kind".set_position(Vector2((screen_size.x/2-kindButton_size.x)/2, (screen_size.y-kindButton_size.y)/2))
			$"维护/place".set_position(Vector2(screen_size.x/2+(screen_size.x/2-placeButton_size.x)/2, (screen_size.y-placeButton_size.y)/2))
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(_delta):
#	pass


func _on_MainPage_resized():
	resize(0)
	resize(1)
	resize(2)
	resize(3)
	

signal logout
func _on_ToolButton_pressed():
	var config = ConfigFile.new()
	config.set_value("user_account","account",0)
	config.set_value("user_account","password",0)
	config.save("user://user_account.save")
	emit_signal("logout")

var allCatInfo_scene = preload("res://mianFunction/allCatInfo/AllCatInfo.tscn")
var allCatInfo
func _on_allCatInfo_pressed():
	allCatInfo = allCatInfo_scene.instance()
	add_child(allCatInfo)
	allCatInfo.connect("allCatInfo_back",self,"_on_allCatInfo_back")
	pass # Replace with function body.
func _on_allCatInfo_back():
	remove_child(allCatInfo)
	allCatInfo.queue_free()

var searchCat_scene = preload("res://mianFunction/searchCat/SearchCat.tscn")
var searchCat
func _on_searchCatInfo_pressed():
	searchCat = searchCat_scene.instance()
	add_child(searchCat)
	searchCat.connect("searchCat_back",self,"_on_searchCat_back")
func _on_searchCat_back():
	remove_child(searchCat)
	searchCat.queue_free()

var manageKind_scene = preload("res://mianFunction/manageKinds/ManageKinds.tscn")
var manageKind
func _on_kind_pressed():
	manageKind = manageKind_scene.instance()
	add_child(manageKind)
	manageKind.connect("back",self,"_on_manageKind_back")

func _on_manageKind_back():
	remove_child(manageKind)
	manageKind.queue_free()
	pass

var managePlace_scene = preload("res://mianFunction/managePlaces/ManagePlaces.tscn")
var managePlace
func _on_place_pressed():
	managePlace = managePlace_scene.instance()
	add_child(managePlace)
	managePlace.connect("back",self,"_on_managePlace_back")

func _on_managePlace_back():
	remove_child(managePlace)
	managePlace.queue_free()

var allFeedCard_scene = preload("res://mianFunction/feed_card/AllFeedCard.tscn")
var allFeedCard
func _on_all_feed_pressed():
	allFeedCard = allFeedCard_scene.instance()
	add_child(allFeedCard)
	allFeedCard.connect("back",self,"_on_allFeed_back")
	pass # Replace with function body.
func _on_allFeed_back():
	remove_child(allFeedCard)
	allFeedCard.queue_free()

var allPosition_scene = preload("res://mianFunction/plosition_card/AllPositionCard.tscn")
var allPosition
func _on_all_position_pressed():
	allPosition = allPosition_scene.instance()
	add_child(allPosition)
	allPosition.connect("back",self,"_on_allPosition_back")
	pass # Replace with function body.
func _on_allPosition_back():
	remove_child(allPosition)
	allPosition.queue_free()

func _on_feed_card_pressed():
	var screen_size = get_viewport().get_visible_rect().size
	screen_size.y -= $"用户信息".get_rect().position.y
	$"打卡/addFeed_dialog".popup_centered(screen_size*0.8)
	pass # Replace with function body.


func _on_position_card_pressed():
	var screen_size = get_viewport().get_visible_rect().size
	screen_size.y -= $"用户信息".get_rect().position.y
	$"打卡/addPosition_dialog".popup_centered(screen_size*0.8)
