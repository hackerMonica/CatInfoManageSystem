extends Node


signal back()

const GetAll  :int = 0	
const Delete  :int = 1
const Add     :int = 2

var _client
# Called when the node enters the scene tree for the first time.
func _ready():
	_client = HTTPRequest.new()
	add_child(_client)
	_client.connect("request_completed", self, "_on_data_received")
	get_all_kind()
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
			var rows =[]
			for value in values:
				var row =[value['place_id'],value['place_name']]
				rows.push_back(row)
			$Table.set_rows(rows)
		Delete:
			if values:
				get_all_kind()
		Add:
			if values:
				get_all_kind()

func send_message(fun,body):
	var headers = ["Content-Type: application/x-www-form-urlencoded","Content-Length:"+str(body.length())
	,"User-Agent: Pirulo/1.0 (Godot)","Accept: */*"]
	var error = _client.request(GlobalVar.http_url+fun,headers,false,HTTPClient.METHOD_POST, body)
	if error != OK:
		push_error("An error occurred in the HTTP request.")

func resize():
	var screen_size = get_viewport().get_visible_rect().size
	$Table.set_position(screen_size*0.1)
	$Table.set_size(screen_size*0.8-Vector2(0,screen_size.y)*0.1)
	var label_size = $Label.get_rect().size
	$Label.set_position(Vector2((screen_size.x-label_size.x)/2,screen_size.y*0.1-label_size.y))
	var button_size = $backButton.get_rect().size
	$addKind.set_position(Vector2((screen_size.x/2-button_size.x)/2, screen_size.y*0.95-button_size.y))
	button_size = $addKind.get_rect().size
	$backButton.set_position(Vector2(screen_size.x/2+(screen_size.x/2-button_size.x)/2, screen_size.y*0.95-button_size.y))
	$AddDialog.set_size(screen_size*0.6)
	$AddDialog.set_position(screen_size*0.2)


func _on_Table_resized():
	resize()

func get_all_kind():
	send_message("getAllPlace","")

var kind_id_to_delete : int = -1
func _on_Table_CLICK_ROW(value):
	kind_id_to_delete = int(value[0])
	$deleteConfirmDialog.dialog_text="确定要删除 "+value[0]+" : "+value[1]+" ?"
	$deleteConfirmDialog.popup_centered(get_viewport().get_visible_rect().size*0.4)


func _on_deleteConfirmDialog_confirmed():
	if kind_id_to_delete == -1:
		return
	var body = GlobalVar.client.query_string_from_dict({'place_id' : kind_id_to_delete})
	send_message("deletePlace",body)
	pass # Replace with function body.


func _on_addKind_pressed():
	$AddDialog.popup_centered(get_viewport().get_visible_rect().size*0.6)


func _on_AddDialog_addKind(name):
	var body = GlobalVar.client.query_string_from_dict({'place_name' : name})
	send_message("addPlace",body)


func _on_AddDialog_about_to_show():
	$AddDialog/CenterContainer/LineEdit.text = ""


func _on_backButton_pressed():
	emit_signal("back")
