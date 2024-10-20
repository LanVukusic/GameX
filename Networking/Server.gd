@tool
extends Node

const MuliplayerSignalHandler = preload("res://Networking/MultiplayerSignalHandler.gd")

@export var players: Dictionary = {}

# The port we will listen to
const PORT = 9080
# Our WebSocketServer instance
var _server = WebSocketMultiplayerPeer.new()


func _ready():
	
	# Connect base signals to get notified of new client connections,
	# disconnections, and disconnect requests.
	_server.peer_connected.connect(_connected)
	_server.peer_disconnected.connect(_disconnected)
	# This signal is emitted when not using the Multiplayer API every time a
	# full packet is received.
	# Alternatively, you could check get_peer(PEER_ID).get_available_packets()
	# in a loop for each connected peer.
	# _server.data_received.connect(_on_data)
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
	players[id] = MuliplayerSignalHandler.new(id)

func get_player_from_id(id: int):
	return players[id] as MuliplayerSignalHandler

func _disconnected(id, was_clean = false):
	# This is called when a client disconnects, "id" will be the one of the
	# disconnecting client, "was_clean" will tell you if the disconnection
	# was correctly notified by the remote peer before closing the socket.
	print("Client %d disconnected, clean: %s" % [id, str(was_clean)])
	get_player_from_id(id).xMove.emit(12.8)
	players.erase(id)


# func _on_data(id):
# 	# Print the received packet, you MUST always use get_peer(id).get_packet to receive data,
# 	# and not get_packet directly when not using the MultiplayerAPI.
# 	var pkt = _server.get_peer(id).get_packet()
# 	print("Got data from client %d: %s ... echoing" % [id, pkt.get_string_from_utf8()])
# 	_server.get_peer(id).put_packet(pkt)

func handle_packet(data: Variant, peerId: int):
	var player = get_player_from_id(peerId)
	if player == null:
		return

	if (data["type"] == "move"):
		player.xMove.emit(data["x"])
		player.yMove.emit(data["y"])
	pass


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