class_name MultiplayerSignalHandler
extends Node

  
var multiplayerId: int = 0

signal moveVec(vec: Vector2)
signal lookVec(vec: Vector2)
signal lamp()


func print_sig2():
  print(multiplayerId)

func print_sig(val: Vector2):
  print(val, " ", multiplayerId)

func _init(id: int):
  multiplayerId = id
  moveVec.connect(print_sig)
  lookVec.connect(print_sig)
  lamp.connect(print_sig2)
