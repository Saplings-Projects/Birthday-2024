extends Control
class_name StaticControlNode

@export var updateDelay : float = 0.5

var _myParent : Control
var _timer : float
var _mousedOver : bool
var _lastPosition : Vector2
var _lastRotation : float

func _onMouseEnter():
	_mousedOver = true

func _onMouseExit():
	_mousedOver = false

func _initialize():
	size = _myParent.size
	position = Vector2.ZERO
	pivot_offset = Vector2(size.x * 0.5, size.y * 0.5)
	_timer = updateDelay
	_lastPosition = _myParent.position
	_lastRotation = _myParent.rotation

func _ready():
	_myParent = get_parent_control()
	set_anchors_preset(Control.PRESET_CENTER)
	_timer = updateDelay;
	_mousedOver = false
	mouse_entered.connect(_onMouseEnter)
	mouse_exited.connect(_onMouseExit)
	
	_initialize()
	get_tree().get_root().size_changed.connect(_initialize)

func _process(delta):
	_timer -= delta
	if _mousedOver:
		_timer = updateDelay
	if _timer < 0:
		_initialize()
		
	if _myParent.rotation != _lastRotation:
		rotation = -_myParent.rotation
		_initialize()
	
	var moveDifference : Vector2 = _myParent.position - _lastPosition
	position -= moveDifference
	_lastPosition = _myParent.position
	
func _exit_tree():
	get_tree().get_root().size_changed.disconnect(_initialize)
