extends CanvasLayer
class_name UIManager

@export var PlayerUIScene: PackedScene

@onready var uiRoot = %UIRoot

@export var nodesToIds: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta: float) -> void:
# 	pass

func init_UIPlayerNode(player: Player, peerId: int):
	var PlayerUINode = PlayerUIScene.instantiate() as UIPlayerNode
	PlayerUINode.connected_player = player
	PlayerUINode.connect_singals()
	uiRoot.add_child(PlayerUINode)
	nodesToIds[peerId] = PlayerUINode

func remove_UIPlayerNode(peerId: int):
	nodesToIds[peerId].queue_free()
