extends Node

@export var myScreen : ScreenLogic
@export var splashDuration : float = 2
@export var entryWait : float = 0.5

var _inputWaitTimer : float = 0
var _timer : float = 0
var _active : bool = false

func ScreenEnter():
	_active = true
	_timer = splashDuration
	_inputWaitTimer = entryWait
	pass

func GoToMainMenu():
	myScreen.GoToScreen(load("res://MainScenes/main_menu.tscn"), {}, ScreenManager.TransitionStyle.TURN_PAGE)

func _process(delta):
	if _active == false:
		return
	
	_inputWaitTimer -= delta
	_timer -= delta
	if _timer < 0 and _inputWaitTimer < 0:
		GoToMainMenu()

func _input(event):
	if event.is_action_pressed("GrabPiece"):
		_timer = 0
