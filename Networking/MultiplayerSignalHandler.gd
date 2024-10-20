extends Node

  
var multiplayerId: int = 0

signal xMove(x: float)
signal yMove(y: float)
signal xLook(x: float)
signal yLook(y: float)


func print_sig(val: float):
  print(val, " ", multiplayerId)

func _init(id: int):
  multiplayerId = id
  xMove.connect(print_sig)
  yMove.connect(print_sig)
  xLook.connect(print_sig)
  yLook.connect(print_sig)
