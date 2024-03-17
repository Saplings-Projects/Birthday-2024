extends Control
class_name StaticControlNode

var _myParent : Control
var _startingPosition : Vector2

func _initialize():
	size = _myParent.size
	position = Vector2.ZERO
	_startingPosition = global_position

func _ready():
	_myParent = get_parent_control()
	_initialize()
	get_tree().get_root().size_changed.connect(_initialize)

func _process(delta):
	global_position = _startingPosition
	
func _exit_tree():
	get_tree().get_root().size_changed.disconnect(_initialize)
