class_name Vaza
extends Damagable

func imdead():
  print("aaaa asjasdjasd")

func _ready() -> void:
  died.connect(imdead)
