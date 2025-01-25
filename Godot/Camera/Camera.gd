extends Camera2D
class_name MultiplayerCamera

@export_category("Camera follow properties")
@export var player_padding: int = 100
@export var min_zoom: float = 1.5

var pos_zoom_ratio: Vector2 = Vector2(1, 1)


func _ready() -> void:
	pos_zoom_ratio = get_viewport().get_visible_rect().size

func _physics_process(_delta: float) -> void:
	var players = get_tree().get_nodes_in_group("Player")
	if (len(players) == 0):
		return

	var min_x = INF
	var min_y = INF
	var max_x = -INF
	var max_y = -INF

	for player in players:
		var p = player as Player
		# needs global position because position is wrong when player is parented
		max_x = max(max_x, p.global_position.x)
		max_y = max(max_y, p.global_position.y)
		min_x = min(min_x, p.global_position.x)
		min_y = min(min_y, p.global_position.y)

  
	# Bounding rect calculation
	var center = Vector2(
	(max_x + min_x) / 2.0,
	(max_y + min_y) / 2.0
	)

	# position camera in the middle of the players bounding rectangle
	self.position = center

	# zoom calculation
	var zoom_x = ((max_x - min_x) + player_padding) / pos_zoom_ratio.x
	var zoom_y = ((max_y - min_y) + player_padding) / pos_zoom_ratio.y

	var zoom_set = max(zoom_x, zoom_y, min_zoom)
	self.zoom = Vector2(1.0 / zoom_set, 1.0 / zoom_set)
