extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
signal searchCat_back()

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
	$popup_cat_detail.hide_button()
#	popup = detail_popup_scene.instance()
#	add_child(popup)
#	popup.connect("deleteComfirm",self,"_on_deleteComfirm")
	resize()
var allCat:Array = []
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
			allCat = rows

func send_message(fun,body):
	var headers = ["Content-Type: application/json","Content-Length:"+str(body.length())
	,"User-Agent: Pirulo/1.0 (Godot)","Accept: */*"]
	var error = _client.request(GlobalVar.http_url+fun,headers,false,HTTPClient.METHOD_POST, body)
	if error != OK:
		push_error("An error occurred in the HTTP request.")
func get_all_cat_info():
	send_message("get_all_cat_info","")

func _on_Table_CLICK_ROW(value):
	var screen_size = get_viewport().get_visible_rect().size
	$popup_cat_detail.set_value(value)
	$popup_cat_detail.set_size(Vector2(screen_size.x,screen_size.y)*0.7)
	$popup_cat_detail.popup_centered()

func resize():
	var screen_size = get_viewport().get_visible_rect().size
	var button_size = $searchButton.get_rect().size
	var content_size = $searchContent.get_rect().size
	$searchContent.set_position(Vector2((screen_size.x-button_size.x-content_size.x)/2,screen_size.y*0.14-button_size.y))
	$searchButton.set_position($searchContent.get_rect().position+Vector2(content_size.x,0))
	var offset = Vector2(0,screen_size.y)*0.1
	$Table.set_position(screen_size*0.1+offset)
	$Table.set_size(screen_size*0.8-offset*2)
	var label_size = $Label.get_rect().size
	$Label.set_position(Vector2((screen_size.x-label_size.x)/2,screen_size.y*0.1-label_size.y)+offset)
	$popup_cat_detail.resize(screen_size)
	$popup_cat_detail.set_size(screen_size*0.7)
	$popup_cat_detail.set_position(screen_size*0.15+offset)
	$ColorRect.set_size(screen_size)
	button_size = $Button.get_rect().size
	$Button.set_position(Vector2((screen_size.x-button_size.x)/2, screen_size.y*0.95-button_size.y))


func _on_Table_resized():
	resize()


func _on_searchButton_pressed():
	var text = $searchContent.text
	if text == "":
		$Table.set_rows(allCat)
		return
	if text.is_valid_integer():
		var rows = []
		for cat in allCat:
			if cat[0].find(text)!=-1:
				rows.push_back(cat)
		$Table.set_rows(rows)
	else :
		var rows = []
		for cat in allCat:
			if cat[1].find(text)!=-1:
				rows.push_back(cat)
		$Table.set_rows(rows)


func _on_Button_pressed():
	emit_signal("searchCat_back")
