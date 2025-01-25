@tool
extends Node2D
class_name AimIndicator

var first_line: Line2D
var mid_line: Line2D
var second_line: Line2D

@export_category("Runtime config")
@export var angle: float = PI / 4.0
@export var length: float = 300.0

@export_category("One time config")
@export var color_grad: Gradient
@export var width: float = 4.0

func create_line() -> Line2D:
	var line = Line2D.new()
	var points: PackedVector2Array = PackedVector2Array()
	points.append(Vector2(0, 0))
	points.append(Vector2(0, 0))
	line.points = points
	line.gradient = color_grad
	line.begin_cap_mode = Line2D.LINE_CAP_ROUND
	line.width = width
	return line

func init_lines():
	first_line = create_line()
	add_child(first_line)
	mid_line = create_line()
	mid_line.width = width / 2.0
	add_child(mid_line)
	second_line = create_line()
	add_child(second_line)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	init_lines()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# if Engine.is_editor_hint():
	# 	init_lines()


	var half_angle = angle / 2.0
	var angle_vec_up = Vector2.from_angle(half_angle).normalized()
	var angle_mid = Vector2.from_angle(0).normalized()
	var angle_vec_down = Vector2.from_angle(-1 * half_angle).normalized()

	first_line.points[1] = angle_vec_up
	first_line.points[1] *= length

	mid_line.points[1] = angle_mid
	mid_line.points[1] *= length * 2

	second_line.points[1] = angle_vec_down
	second_line.points[1] *= length
