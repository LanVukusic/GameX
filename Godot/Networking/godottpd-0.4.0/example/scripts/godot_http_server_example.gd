extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var server = HttpServer.new(false, 1234)
	server.register_router("/*", HttpFileRouter.new("/home/lanv/Documents/gejmich/Controller_web/dist"))
	add_child(server)
	server.enable_cors(["http://localhost:1234"])
	server.start()
