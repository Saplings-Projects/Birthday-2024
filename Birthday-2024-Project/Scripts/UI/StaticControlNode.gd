extends Control
class_name StaticControlNode

var _startingPosition : Vector2

func _ready():
	var parent : Control = get_parent_control()
	size = parent.size
	position = Vector2.ZERO
	_startingPosition = global_position

func _process(delta):
	global_position = _startingPosition
