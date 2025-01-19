extends CanvasLayer
class_name UIManager

@export var PlayerUIScene: PackedScene

@onready var uiRoot = %UIRoot

@export var nodesToIds: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func init_UIPlayerNode(player: Player, peerId: int):
	var PlayerUINode = PlayerUIScene.instantiate() as UIPlayerNode
	PlayerUINode.connected_player = player
	uiRoot.add_child(PlayerUINode)
	nodesToIds[peerId] = PlayerUINode
	print("initing playyer ", player.name, " with id ", peerId)

func remove_UIPlayerNode(peerId: int):
	nodesToIds[peerId].queue_free()
