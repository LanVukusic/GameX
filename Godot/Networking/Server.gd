# @tool
extends Node
class_name SocketServer

@export_category("UI")
@export var uIManager: UIManager

@export_category("Positioning and players")
@export var players: Dictionary = {}
@export var player_root: Node2D


@export_category("NETWORK")
# The port we will listen to
var PORT = 9999

# Our WebSocketServer instance
var _server = WebSocketMultiplayerPeer.new()
var playerScene = preload("res://Entities/Player/Player.tscn")

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
	print("Connection established with ", id)
	# This is called when a new peer connects, "id" will be the assigned peer id,
	# print("Client %d connected " % [id])
	# var newPlayer = playerScene.instantiate() as Player
	# players[id] = newPlayer
	# newPlayer.visible = true
	# newPlayer.moveSpeed = 600
	# newPlayer.multiplayerId = id
	# player_root.add_child(newPlayer)
	pass
	# newPlayer.owner = self.get_parent()
	# if self.get_parent() == null:
	# 	newPlayer.owner = self
	# else:
	# 	newPlayer.owner = self.get_parent()


func get_player_from_id(id: int):
	if (players.has(id) && is_instance_valid(players[id])):
		return players[id] as Player
	return null

func _disconnected(id, was_clean = false):
	# This is called when a client disconnects, "id" will be the one of the
	# disconnecting client, "was_clean" will tell you if the disconnection
	# was correctly notified by the remote peer before closing the socket.
	print("Client %d disconnected, clean: %s" % [id, str(was_clean)])
	if (players.has(id) != null && is_instance_valid(players[id])):
		players[id].queue_free()
		uIManager.remove_UIPlayerNode(id)
		players.erase(id)


func handle_packet_json(data: Variant, peerId: int):
	var player_inst = get_player_from_id(peerId)

	if (data["t"] == "join"):
		if (player_inst != null):
			print("rejoin detected")
			return

		print("Client %d connected " % [peerId])
		player_inst = playerScene.instantiate() as Player
		player_inst.visible = true
		player_inst.multiplayerId = peerId
		player_root.add_child(player_inst)
		player_inst.joined.emit(Color(data["color"]), data["name"])
		players[peerId] = player_inst

		# init player UI
		uIManager.init_UIPlayerNode(player_inst, peerId)
		player_inst.joined.emit(Color(data["color"]), data["name"])
		return


	if player_inst == null:
		print("no player found")
		return
	
	match data["t"]:
		"reload":
			player_inst.weapon_manager.current_weapon.reload_active.emit()
		
		"switch_w":
			player_inst.weapon_manager.switch_weapons_pressed.emit()

		"shoot":
			if (data["state"] == "active"):
				player_inst.weapon_manager.current_weapon.shoot_pressed.emit()
			if (data["state"] == "release"):
				player_inst.weapon_manager.current_weapon.shoot_released.emit()

		"light":
			player_inst.toggle_lamp()
			return

func handle_packet_binary(data: PackedByteArray, peerId: int):
	var player_inst = get_player_from_id(peerId)
	if (player_inst == null || !is_instance_valid(player_inst)):
		return

	# we got a byte message : MOVE or LOOK
	if (data.slice(1, 2).decode_u8(0) == 1):
		var x = data.slice(2, 6).decode_float(0)
		var y = data.slice(6, 10).decode_float(0)
		player_inst.move_input_component.handle_input(Vector2(x, y * -1))
		# print(x, " ", y, " move")
		return

	if (data.slice(1, 2).decode_u8(0) == 2):
		# LOOK
		var x = data.slice(2, 6).decode_float(0)
		var y = data.slice(6, 10).decode_float(0)
		player_inst.look_input_component.handle_look_direction(Vector2(x, -1 * y))
		# print(x, " ", y, " look")
		return


func _process(_delta):
	_server.poll()
	var state = _server.get_connection_status()
	if state == MultiplayerPeer.CONNECTION_CONNECTED:
		while _server.get_available_packet_count():
			var ownerId = _server.get_packet_peer()
			var bytes: PackedByteArray = _server.get_packet()
			# byte msg handling for move and look
			if (bytes.slice(0, 1).decode_u8(0) == 0):
				handle_packet_binary(bytes, ownerId)
				return

			# json message
			var json = JSON.new()
			var json_str = bytes.slice(1).get_string_from_ascii()
			var error = json.parse(json_str)
			print(json.data)
			if error:
				print("ERROR")
			else:
				handle_packet_json(json.data, ownerId)

	elif state == MultiplayerPeer.CONNECTION_DISCONNECTED:
		var code = _server.get_close_code()
		var reason = _server.get_close_reason()
		print("WebSocket closed with code: %d, reason %s. Clean: %s" % [code, reason, code != -1])
		set_process(false) # Stop processing.
