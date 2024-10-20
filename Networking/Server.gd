@tool
extends Node

# var handler = MultiplayerSignalHandler

@export var players: Dictionary = {}

# The port we will listen to
const PORT = 9999
# Our WebSocketServer instance
var _server = WebSocketMultiplayerPeer.new()
var player = preload("res://Entities/Player.tscn")


func _ready():
	
	# Connect base signals to get notified of new client connections,
	# disconnections, and disconnect requests.
	_server.peer_connected.connect(_connected)
	_server.peer_disconnected.connect(_disconnected)
	# Start listening on the given port.
	var err = _server.create_server(PORT)
	if err != OK:
		print("Unable to start server")
		set_process(false)
	else:
		print("Server started on:", PORT)

func _connected(id):
	# This is called when a new peer connects, "id" will be the assigned peer id,
	# "proto" will be the selected WebSocket sub-protocol (which is optional)
	print("Client %d connected " % [id])
	var newPlayer = player.instantiate()
	self.add_child(newPlayer)
	newPlayer.visible = true
	newPlayer.moveSpeed = 600
	newPlayer.multiplayerId = id
	players[id] = newPlayer

func get_player_from_id(id: int):
	return players[id] as Player

func _disconnected(id, was_clean = false):
	# This is called when a client disconnects, "id" will be the one of the
	# disconnecting client, "was_clean" will tell you if the disconnection
	# was correctly notified by the remote peer before closing the socket.
	print("Client %d disconnected, clean: %s" % [id, str(was_clean)])
	players[id].queue_free()
	players.erase(id)


func handle_packet(data: Variant, peerId: int):
	var player_inst = get_player_from_id(peerId)
	print(peerId)
	if player_inst == null:
		return

	if (data["t"] == "move"):
		player_inst.moveVec.emit(Vector2(data["x"], -1 * data["y"]))
	# if (data["t"] == "look"):
	# 	player_inst.lookVec.emit(Vector2(data["x"], data["y"]))
	# if (data["t"] == "light"):
	# 	player_inst.lamp.emit()


func _process(_delta):
	_server.poll()
	var state = _server.get_connection_status()
	if state == MultiplayerPeer.CONNECTION_CONNECTED:
		while _server.get_available_packet_count():
			var ownerId = _server.get_packet_peer()
			var json = JSON.new()
			var json_str = _server.get_packet().get_string_from_ascii()
			var error = json.parse(json_str)
			if error:
				print("ERROR")
			else:
				handle_packet(json.data, ownerId)
				# print("Packet: ", ownerId, " ", json.data["type"])

	elif state == MultiplayerPeer.CONNECTION_DISCONNECTED:
		var code = _server.get_close_code()
		var reason = _server.get_close_reason()
		print("WebSocket closed with code: %d, reason %s. Clean: %s" % [code, reason, code != -1])
		set_process(false) # Stop processing.
