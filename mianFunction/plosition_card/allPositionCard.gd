extends Node

signal back()
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var _client
# Called when the node enters the scene tree for the first time.
func _ready():
	_client = HTTPRequest.new()
	add_child(_client)
	_client.connect("request_completed", self, "_on_data_received")
	get_all_place_card()
	resize()
	$WindowDialog.head(["用户","猫咪","时间","地点","描述"])
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _on_data_received(_result, response_code, _headers, body):
	var json_return :JSONParseResult = JSON.parse(body.get_string_from_utf8())
	if(json_return.error!=OK):
		push_error(json_return.error_string)
		return
	if response_code!=200:
		push_error("server connection problem\n")
		return
	var values = json_return.result['value']
	var rows = []
	for value in values:
		var row = []
		row.push_back(value["user_name"])
		row.push_back(value["cat_name"])
		row.push_back(value["card_date"])
		row.push_back(value["card_place"])
		row.push_back(str(value["card_description"]))
		rows.push_back(row)
	$Table.set_rows(rows)

func send_message(fun,body):
	var headers = ["Content-Type: application/x-www-form-urlencoded","Content-Length:"+str(body.length())
	,"User-Agent: Pirulo/1.0 (Godot)","Accept: */*"]
	var error = _client.request(GlobalVar.http_url+fun,headers,false,HTTPClient.METHOD_POST, body)
	if error != OK:
		push_error("An error occurred in the HTTP request.")
func get_all_place_card():
	send_message("allPlaceCard","")

func resize():
	var screen_size = get_viewport().get_visible_rect().size
	$Table.set_position(screen_size*0.1)
	$Table.set_size(screen_size*0.8-Vector2(0,screen_size.y)*0.1)
	var label_size = $Label.get_rect().size
	$Label.set_position(Vector2((screen_size.x-label_size.x)/2,screen_size.y*0.1-label_size.y))
	var button_size = $Button.get_rect().size
	$Button.set_position(Vector2((screen_size.x-button_size.x)/2, screen_size.y*0.95-button_size.y))
	$ColorRect.set_size(screen_size)
	$WindowDialog.set_size(screen_size*0.6)
	$WindowDialog.set_position(screen_size*0.2)


func _on_Button_pressed():
	emit_signal("back")

func _on_Table_CLICK_ROW(value):
	$WindowDialog.set_value(value)
	var screen_size = $ColorRect.get_rect().size
	$WindowDialog.popup_centered(screen_size*0.6)
	resize()
