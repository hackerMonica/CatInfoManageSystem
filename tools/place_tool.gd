extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal recieved(places)

var _client
# Called when the node enters the scene tree for the first time.
func _ready():
	_client = HTTPRequest.new()
	add_child(_client)
	_client.connect("request_completed", self, "_on_data_received")
	pass # Replace with function body.

func _on_data_received(_result, response_code, _headers, body):
	var json_return :JSONParseResult = JSON.parse(body.get_string_from_utf8())
	if(json_return.error!=OK):
		push_error(json_return.error_string)
		return
	if response_code!=200:
		push_error("server connection problem\n")
		return
	var values = json_return.result['value']
	var rows ={}
	for value in values:
		rows[value['place_id']]=value['place_name']
	emit_signal("recieved",rows)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func send_message(fun,body):
	var headers = ["Content-Type: application/x-www-form-urlencoded","Content-Length:"+str(body.length())
	,"User-Agent: Pirulo/1.0 (Godot)","Accept: */*"]
	var error = _client.request(GlobalVar.http_url+fun,headers,false,HTTPClient.METHOD_POST, body)
	if error != OK:
		push_error("An error occurred in the HTTP request.")

func getAllPlace():
	send_message("getAllPlace","")

