# @tool
extends Node


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
	if (players.has(id)):
		return players[id] as Player
	return null

func _disconnected(id, was_clean = false):
	# This is called when a client disconnects, "id" will be the one of the
	# disconnecting client, "was_clean" will tell you if the disconnection
	# was correctly notified by the remote peer before closing the socket.
	print("Client %d disconnected, clean: %s" % [id, str(was_clean)])
	if (players.has(id)):
		players[id].queue_free()
		players.erase(id)
		uIManager.remove_UIPlayerNode(id)


func handle_packet(data: Variant, peerId: int):
	var player_inst = get_player_from_id(peerId)

	if (data["t"] == "join"):
		if (player_inst != null):
			print("rejoin detected")
			return
			# players.erase(peerId)
			# player_inst.queue_free()

		print("Client %d connected " % [peerId])
		player_inst = playerScene.instantiate() as Player
		player_inst.visible = true
		player_inst.multiplayerId = peerId
		player_root.add_child(player_inst)
		player_inst.joined.emit(Color(data["color"]), data["name"])
		players[peerId] = player_inst

		# init player UI
		uIManager.init_UIPlayerNode(player_inst, peerId)
		return

	# Find the instantiated player associated with the current peerId

	if player_inst == null:
		print("no player found")
		return
	
	match data["t"]:
		"move":
			player_inst.moveVec.emit(Vector2(data["x"], -1 * data["y"]))
			return

		"look":
			player_inst.lookVec.emit(Vector2(data["x"], -1 * data["y"]))
			return

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
			player_inst.lamp.emit()
			return

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

	elif state == MultiplayerPeer.CONNECTION_DISCONNECTED:
		var code = _server.get_close_code()
		var reason = _server.get_close_reason()
		print("WebSocket closed with code: %d, reason %s. Clean: %s" % [code, reason, code != -1])
		set_process(false) # Stop processing.
