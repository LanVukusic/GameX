extends Node
# THIS SCRIPT IS AUTOLOADED

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var server = HttpServer.new(false, 1234)
	server.register_router("/*", HttpFileRouter.new("res://Networking/HTTP/dist"))
	add_child(server)
	server.enable_cors(["http://localhost:1234"])
	server.start()
	print("Static game server running on http://localhost:1234")
