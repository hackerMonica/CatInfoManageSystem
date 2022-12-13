extends Node
var Difficulty
var score = 0
var have_boss = 0
var GameLevel = 0 # 0, 1, 2 for easy normal hard
var screen_size

# Multi-player
var is_multiplayer_mode = true
var is_login = false

# Signals
signal update_multi_player_score(raw_data)
signal backend_login_callback(message)
signal backend_signup_callback(message)
signal backend_leaderboard_callback(data)



var userName: String
var passWord: String

# Commands
const GetAllUsers = 0
const JoinUser = 1
const StartMultiplayerGame = 2
const ReportScore = 3
const GetLeaderBoard = 4
const Login = 5
const Signup = 6

# The URL we will connect to.
export var websocket_url = "wss://trivialwar.eastonman.com/socket"
#export var websocket_url = "ws://localhost:8080/socket"

# Our WebSocketClient instance.
var _client = WebSocketClient.new()

func _ready():
	screen_size = get_viewport().get_visible_rect().size
	print("Screen size" + str(screen_size))
	
	# Initiate connection to the given URL.
	_client.connect("connection_established", self, "_connected")
	_client.connect("data_received", self, "_on_data_received")
	var err = _client.connect_to_url(websocket_url, [], false, ["Host: trivialwar.eastonman.com"])
#	var err = _client.connect_to_url(websocket_url)
	if err != OK:
		print("Unable to connect")
		set_process(false)
	
func _connected(proto = ""):
	print("Connected to " + websocket_url)
	
	
	
func _on_data_received():
	var data = _client.get_peer(1).get_packet().get_string_from_utf8()
	print("Got data from server: ", data)
	var packet = JSON.parse(data).result
	data = packet['data']
	if packet['type'] == GetLeaderBoard:
		emit_signal("backend_leaderboard_callback", data)
	elif packet['type'] == ReportScore:
		emit_signal("update_multi_player_score", data)
	elif packet['type'] == Login:
		emit_signal("backend_login_callback", data)
	elif packet['type'] == Signup:
		emit_signal("backend_signup_callback", data)
	else:
		print("Undefined Type")
	

func send_message(message):
	_client.get_peer(1).put_packet(message.to_utf8())
	
	
# Backend communication func
func backend_login():
	var info = {"username": userName, "hash": passWord.sha256_text()}
	var wsreq = {"type": Login, "param": JSON.print(info)}
	send_message(JSON.print(wsreq))
func backend_signup():
	var info = {"username": userName, "hash": passWord.sha256_text()}
	var wsreq = {"type": Signup, "param": JSON.print(info)}
	send_message(JSON.print(wsreq))
func backend_report_score():
	var wsreq = {"type": GlobalVar.ReportScore, "param": str(GlobalVar.score)}
	send_message(JSON.print(wsreq))
	
	
func _process(delta):
	_client.poll()
	
func _exit_tree():
	_client.disconnect_from_host()
