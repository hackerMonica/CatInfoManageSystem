extends WindowDialog

const GetAll  :int = 0	
const Delete  :int = 1
const Add     :int = 2
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var _client
# Called when the node enters the scene tree for the first time.
func _ready():
	_client = HTTPRequest.new()
	add_child(_client)
	_client.connect("request_completed", self, "_on_data_received")
#	self.popup()
	pass # Replace with function body.

func _on_data_received(_result, response_code, _headers, body):
	print(body.get_string_from_utf8())
	var json_return :JSONParseResult = JSON.parse(body.get_string_from_utf8())
	if(json_return.error!=OK):
		push_error(json_return.error_string)
		return
	if response_code!=200:
		push_error("server connection problem\n")
		return

func send_message(fun,body):
	var headers = ["Content-Type: application/x-www-form-urlencoded","Content-Length:"+str(body.length())
	,"User-Agent: Pirulo/1.0 (Godot)","Accept: */*"]
	var error = _client.request(GlobalVar.http_url+fun,headers,false,HTTPClient.METHOD_POST, body)
	if error != OK:
		push_error("An error occurred in the HTTP request.")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
var cat_id
var place_id
var feed_food
var u_id

func _on_Button_pressed():
	var text = $VBoxContainer/feed_food/TextEdit.text
	cat_id = cat_id_array[$VBoxContainer/cat_id/Label2.selected]
	place_id = place_id_array[$VBoxContainer/place_name/Label2.selected]
	feed_food = text
	u_id = GlobalVar.u_id
	var body = GlobalVar.client.query_string_from_dict({'u_id' : u_id,
			'cat_id':cat_id,'place_id':place_id,'record_description':feed_food})
	send_message("addPositionCard",body)
	hide()

var cat_id_array :Array = []
func _on_cat_tool_recieved(cats):
	var index:int = 1
	cat_id_array.clear()
	$VBoxContainer/cat_id/Label2.clear()
	for cat in cats:
		$VBoxContainer/cat_id/Label2.add_item(cats[cat],index)
		cat_id_array.push_back(cat)
		index+=1

var place_id_array :Array = []
func _on_place_tool_recieved(places):
	var index:int = 1
	$VBoxContainer/place_name/Label2.clear()
	place_id_array.clear()
	for place in places:
		$VBoxContainer/place_name/Label2.add_item(places[place],index)
		place_id_array.push_back(place)
		index+=1
	pass # Replace with function body.

func resize():
	var screen_size = get_rect().size
	var button_size = $Button.get_rect().size
	$Button.set_position(Vector2((screen_size-button_size).x/2,screen_size.y*0.9))


func _on_WindowDialog_about_to_show():
	$cat_tool.getAllCat()
	$place_tool.getAllPlace()
	$VBoxContainer/feed_food/TextEdit.text=""

