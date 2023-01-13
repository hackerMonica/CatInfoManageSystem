extends Node
var Difficulty
var score = 0
var GameLevel = 0 # 0, 1, 2 for easy normal hard

# Multi-player
var is_login = false

# Signals
signal backend_login_callback(message,errorCode)
signal backend_signup_callback(message)
signal backend_auto_login_callback(message)

var u_id:int
var account: String
var passWord: String
var username: String
var sex: int
var description : String
var is_admin :bool = false

# Commands
const Login     :int = 0	
const Signup    :int = 1
const AutoLogin :int = 2

# The URL we will connect to.
export var http_url = "http://116.205.178.115/"
#export var websocket_url = "ws://localhost:8080/socket"

# Our WebSocketClient instance.
var _client
var client = HTTPClient.new()
func _ready():
	_client = HTTPRequest.new()
	add_child(_client)
	_client.connect("request_completed", self, "_on_data_received")	

func _on_data_received(_result, response_code, _headers, body):
	print(str(_result)+'\n')
	print(str(response_code)+'\n')
	print(str(_headers))
	print(body.get_string_from_utf8()+"\n")
	var json_return :JSONParseResult = JSON.parse(body.get_string_from_utf8())
	if response_code!=200:
		push_error("server connection problem")
	if(json_return.error!=OK):
		push_error(json_return.error_string)
		return
	var type : int = json_return.result['type']
	var errorCode = json_return.result['error']
	var value
	match type:
		Login:
			# print(str(value)+"\n")
			# print(str(value.u_password)+'\n')
			# print(str(value['u_password'])+'\n')
			# print(passWord+'\n')
			if(errorCode==0):
				value = json_return.result['value'][0]
			if json_return.result['error']==1:
				emit_signal("backend_login_callback",false,errorCode)
			elif value['u_password'] == passWord:
				# print("login successful")
				emit_signal("backend_login_callback",true,errorCode)
			else:
				emit_signal("backend_login_callback",false,errorCode)
		Signup:
			value = json_return.result['value']
			if value['result_code']==1:
				print(value['result_message'])
				emit_signal("backend_signup_callback",false)
			elif value['result_code']==0:
				emit_signal("backend_signup_callback",true)
		AutoLogin:
			if(errorCode!=0):
				print("errorCode="+str(errorCode)+"\n")
				emit_signal("backend_auto_login_callback",false)
				return
			value = json_return.result['value'][0]
			if value['u_password']==passWord:
				emit_signal("backend_auto_login_callback",true)
			else:
				emit_signal("backend_auto_login_callback",false)
		_:
			push_error("get wrong data type")


func send_message(fun,body):
	var headers = ["Content-Type: application/x-www-form-urlencoded","Content-Length:"+str(body.length())
	,"User-Agent: Pirulo/1.0 (Godot)","Accept: */*"]
	var error = _client.request(http_url+fun,headers,false,HTTPClient.METHOD_POST, body)
	if error != OK:
		push_error("An error occurred in the HTTP request.")
	
	
# Backend communication func
func backend_login():
	var info = client.query_string_from_dict({"account": account})
	# var wsreq = {"type": Login, "param": JSON.print(info)}
	send_message("login",info)
func backend_signup():
	var info = client.query_string_from_dict({"account": account, "password":passWord,"username":username,"sex":str(sex), "description":description})
	# var wsreq = {"type": Signup, "param": JSON.print(info)}
	send_message("signup",info)
func backend_auto_login():
	var info = GlobalVar.client.query_string_from_dict({"account": account})
	# var wsreq = {"type": Login, "param": JSON.print(info)}
	send_message("autoLogin",info)
	
func _process(_delta):
#	_client.poll()
	pass
	
func _exit_tree():
#	_client.disconnect_from_host()
	pass
