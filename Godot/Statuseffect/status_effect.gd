@tool
extends Node
class_name StatusEffect

var buff_name: String
@export var duration: float
var binded_player: CharacterBody2D

func check_valid_parent() -> PackedStringArray:
	var handler = get_parent()
	if handler.name != "StatusEffectRoot":
		return ["Status effects need to be children of StatusEffectRoot named Node2D"]
	
	binded_player = handler.get_parent()
	if binded_player == null:
		return ["no parent player"]

	return []
	
func _ready() -> void:
	if check_valid_parent() != PackedStringArray([]):
		push_error("No valid parent")
		return
	
	var timer_reset = Timer.new()
	timer_reset.wait = duration
	timer_reset.one_shot = true
	timer_reset.timeout.connect(on_buff_end)
	timer_reset.timeout.connect(_self_destruct)
	on_buff_start()

func on_buff_start():
	pass

func on_buff_end():
	pass
	
func _self_destruct():
	queue_free()

func _get_configuration_warnings() -> PackedStringArray:
	return check_valid_parent()
