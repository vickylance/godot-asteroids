extends Node2D

export var startPoint := Vector2(40, 40)
export var gridSize := Vector2(20, 20)
export var gridGap := Vector2(30, 30)

onready var grid := $Grid
onready var cam := $Camera

var zoom_pos := Vector2.ZERO
var zoom := Vector2.ONE

func _ready():
	for i in range(gridSize.x + 1): # extra 1 to cap bottom end
		var line := Line2D.new()
		line.add_point(Vector2(i * gridGap.x, 0) + startPoint)
		line.add_point(Vector2(i * gridGap.x, gridSize.y * gridGap.y) + startPoint)
		line.width = 1
		grid.add_child(line)
	for i in range(gridSize.y + 1): # extra 1 to cap right side end
		var line := Line2D.new()
		line.add_point(Vector2(0, i * gridGap.y) + startPoint)
		line.add_point(Vector2(gridSize.x * gridGap.x, i * gridGap.y) + startPoint)
		line.width = 1
		grid.add_child(line)

func zoom():
	cam.offset = zoom_pos
	cam.zoom = zoom

func _input(event):
	if event is InputEventGesture:
	if event is InputEventMouseButton:
		if event.is_pressed():
			# zoom in
			if event.button_index == BUTTON_WHEEL_UP:
				print("up")
				zoom_pos = get_global_mouse_position()
				zoom += Vector2.ONE
				# call the zoom function
			# zoom out
			if event.button_index == BUTTON_WHEEL_DOWN:
				print("down")
				zoom_pos = get_global_mouse_position()
				zoom -= Vector2.ONE
				# call the zoom function
