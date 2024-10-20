@tool
extends Node2D
class_name StatusEffect 

var buff_name:String
@export var duration:float
var binded_player:CharacterBody2D

func _ready() -> void:
	binded_player = get_parent().get_parent()
	if binded_player == null:
		push_error("no parent player")
	var timer_reset = Timer.new()
	timer_reset.wait = duration
	timer_reset.one_shot = true
	timer_reset.timeout.connect(on_buff_end)
	timer_reset.timeout.connect(_self_destruct)	
	on_buff_start()

func _get_configuration_warnings() -> PackedStringArray:
	var player = get_parent().get_parent()
	if player == null:
		return["no parent player"]
	return[]

func on_buff_start():
	pass

func on_buff_end():
	pass
	
func _self_destruct():
	queue_free()
