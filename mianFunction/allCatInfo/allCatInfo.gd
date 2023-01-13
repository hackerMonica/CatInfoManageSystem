extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal allCatInfo_back()

const GetAll  :int = 0	
const Delete  :int = 1

#var detail_popup_scene = preload("res://mianFunction/allCatInfo/popup_cat_detail.tscn")
#var popup = detail_popup_scene.instance()
var _client
# Called when the node enters the scene tree for the first time.
func _ready():
	_client = HTTPRequest.new()
	add_child(_client)
	_client.connect("request_completed", self, "_on_data_received")
	get_all_cat_info()
#	popup = detail_popup_scene.instance()
#	add_child(popup)
#	popup.connect("deleteComfirm",self,"_on_deleteComfirm")
	resize()

func _on_data_received(_result, response_code, _headers, body):
	var json_return :JSONParseResult = JSON.parse(body.get_string_from_utf8())
	if(json_return.error!=OK):
		push_error(json_return.error_string)
		return
	if response_code!=200:
		push_error("server connection problem\n")
		return
	var values = json_return.result['value']
	var type : int = json_return.result['type']
	match type:
		GetAll:
			var rows = []
			for value in values:
				var row = []
				row.push_back(value["cat_id"])
				row.push_back(value["cat_name"])
				if value["cat_sex"] == "1":
					row.push_back("男")
				else:
					row.push_back("女")
				row.push_back(value["kind_name"])
				row.push_back(value["cat_color"])
				row.push_back(str(value["cat_description"]))
				rows.push_back(row)
			$Table.set_rows(rows)
		Delete:
			if values:
				get_all_cat_info()
				$popup_cat_detail.hide()

func send_message(fun,body):
	var headers = ["Content-Type: application/x-www-form-urlencoded","Content-Length:"+str(body.length())
	,"User-Agent: Pirulo/1.0 (Godot)","Accept: */*"]
	var error = _client.request(GlobalVar.http_url+fun,headers,false,HTTPClient.METHOD_POST, body)
	if error != OK:
		push_error("An error occurred in the HTTP request.")
func get_all_cat_info():
	send_message("get_all_cat_info","")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Table_CLICK_ROW(value):
	var screen_size = get_viewport().get_visible_rect().size
	$popup_cat_detail.set_value(value)
	$popup_cat_detail.set_size(Vector2(screen_size.x,screen_size.y)*0.7)
	$popup_cat_detail.popup_centered()

func resize():
	var screen_size = get_viewport().get_visible_rect().size
	$Table.set_position(screen_size*0.1)
	$Table.set_size(screen_size*0.8-Vector2(0,screen_size.y)*0.1)
	var label_size = $Label.get_rect().size
	$Label.set_position(Vector2((screen_size.x-label_size.x)/2,screen_size.y*0.1-label_size.y))
	$popup_cat_detail.resize(screen_size)
	$popup_cat_detail.set_size(screen_size*0.7)
	$popup_cat_detail.set_position(screen_size*0.15)
	$ColorRect.set_size(screen_size)
	var button_size = $Button.get_rect().size
	$addCat.set_position(Vector2((screen_size.x/2-button_size.x)/2, screen_size.y*0.95-button_size.y))
	button_size = $addCat.get_rect().size
	$Button.set_position(Vector2(screen_size.x/2+(screen_size.x/2-button_size.x)/2, screen_size.y*0.95-button_size.y))

func _on_Table_resized():
	resize()


func _on_Button_pressed():
	emit_signal("allCatInfo_back")
	pass # Replace with function body.

func _on_addCat_pressed():
	$popup_add_cat.popup_centered(get_viewport().get_visible_rect().size*0.9)
	pass # Replace with function body.

func _on_deleteComfirm(cat_id):
	var body = GlobalVar.client.query_string_from_dict({"cat_id": cat_id})
	send_message("deleteCat",body)
	pass


func _on_popup_add_cat_popup_hide():
	get_all_cat_info()
