extends Node

@export var myScreen : ScreenLogic
@export var splashDuration : float = 2

var _timer : float = 0
var _active : bool = false

func ScreenEnter():
	_active = true
	_timer = splashDuration
	pass

func GoToMainMenu():
	myScreen.GoToScreen(load("res://MainScenes/main_menu.tscn"), {})

func _process(delta):
	if _active == false:
		return
	
	_timer -= delta
	if _timer < 0:
		GoToMainMenu()