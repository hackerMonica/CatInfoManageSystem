extends Control

const AddCat  :int = 2
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var _client
# Called when the node enters the scene tree for the first time.
func _ready():
	resize()
	_client = HTTPRequest.new()
	add_child(_client)
	_client.connect("request_completed", self, "_on_data_received")
	send_message("getAllKind","")
	pass # Replace with function body.

var kind_id:Array =[]
func setKind(kinds:Dictionary):
	var index:int = 0
	kind_id.clear()
	for kind in kinds:
		$InfoField/cat_kind/Label2.add_item(kinds[kind],index)
		kind_id.push_back(kind)
		index+=1

func resize():
	var screen_size = get_rect().size
	$InfoField.set_size(Vector2(screen_size.x,screen_size.y*0.85))
	$Button.set_position(Vector2((screen_size.x-$Button.get_rect().size.x)/2,screen_size.y*0.88))

func _on_Control_resized():
	resize()
	pass # Replace with function body.

func _on_Button_pressed():
	var screen_size = get_rect().size
	if $InfoField/cat_name/Label2.text=="":
		$Popup.set_size(screen_size*0.5)
		$Popup.dialog_text = "您输入的猫咪名称为空！"
		$Popup.popup_centered()
		return
	elif $InfoField/cat_sex/Label2.selected == -1:
		$Popup.set_size(screen_size*0.5)
		$Popup.dialog_text = "您还未选择猫咪性别！"
		$Popup.popup_centered()
		return
	elif $InfoField/cat_kind/Label2.selected == -1:
		$Popup.set_size(screen_size*0.5)
		$Popup.dialog_text = "您还未选择猫咪种类！"
		$Popup.popup_centered()
		return
	elif $InfoField/cat_color/Label2.text == "":
		$Popup.set_size(screen_size*0.5)
		$Popup.dialog_text = "您输入的猫咪颜色为空！"
		$Popup.popup_centered()
		return
	var body = GlobalVar.client.query_string_from_dict({"cat_name":$InfoField/cat_name/Label2.text,
			"cat_sex":$InfoField/cat_sex/Label2.selected,
			"kind_id":kind_id[$InfoField/cat_kind/Label2.selected],
			"cat_color":$InfoField/cat_color/Label2.text,
			"cat_description":$InfoField/cat_description/Label2/TextEdit.text})
	send_message("addCat",body)
	reset()
	hide()

func send_message(fun,body):
	var headers = ["Content-Type: application/x-www-form-urlencoded","Content-Length:"+str(body.length())
	,"User-Agent: Pirulo/1.0 (Godot)","Accept: */*"]
	var error = _client.request(GlobalVar.http_url+fun,headers,false,HTTPClient.METHOD_POST, body)
	if error != OK:
		push_error("An error occurred in the HTTP request.")

func _on_data_received(_result, response_code, _headers, body):
	var json_return :JSONParseResult = JSON.parse(body.get_string_from_utf8())
	if(json_return.error!=OK):
		push_error(json_return.error_string)
		return
	if response_code!=200:
		push_error("server connection problem\n")
		return
	if json_return.result['type'] == AddCat:
		emit_signal("hide")
		return
	var values = json_return.result['value']
	var kinds = {}
	for value in values:
		kinds[value['kind_id']]=value['kind_name']
	setKind(kinds)
	pass

func reset():
	kind_id.clear()
	$InfoField/cat_name/Label2.text=""
	$InfoField/cat_sex/Label2.selected=0
	$InfoField/cat_kind/Label2.selected=0
	$InfoField/cat_color/Label2.text=""
	$InfoField/cat_description/Label2/TextEdit.text=""
