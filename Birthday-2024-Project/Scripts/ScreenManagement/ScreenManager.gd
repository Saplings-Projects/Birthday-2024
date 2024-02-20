class_name ScreenManager
extends Node

@export var popupRoot : CanvasLayer

var lastScreen : String
var _screenStack : Array[Node]

func GoToScreen(screen : PackedScene, data : Dictionary):
	var newScreen = screen.instantiate()
	var screenLogic : ScreenLogic = newScreen as ScreenLogic
	
	if screenLogic.clearScreenStack:
		while _screenStack.size() > 0:
			_closeTopScreen()
	
	screenLogic.screenManager = self
	screenLogic.transitionData = data
	popupRoot.add_child(newScreen)
	_screenStack.push_back(newScreen)
	screenLogic.ScreenEnter.emit()
	
func CloseTopScreen(data : Dictionary):
	if _screenStack.size() == 1:
		printerr("ERROR: cannot close last screen")
		return
	_closeTopScreen()
	var topScreen : ScreenLogic = _screenStack.back() as ScreenLogic
	topScreen.transitionData = data
	topScreen.ScreenEnter.emit()

func ShowSettings():
	GoToScreen(load("res://MainScenes/settings_popup.tscn"), {})

func ShowConfirmationPopup(title : String, body : String, confirm : String = "Confirm", cancel : String = "Cancel"):
	var popupParameters = {}
	popupParameters[ConfirmationPopupController.TITLE_KEY] = title
	popupParameters[ConfirmationPopupController.BODY_KEY] = body
	popupParameters[ConfirmationPopupController.CONFIRM_KEY] = confirm
	popupParameters[ConfirmationPopupController.CANCEL_KEY] = cancel
	GoToScreen(load("res://MainScenes/confirmation_popup.tscn"), popupParameters)

func _ready():
	GoToScreen(load("res://MainScenes/splash_screen.tscn"), {})

func _closeTopScreen():
	var oldScreen : Node = _screenStack.pop_back()
	var screenLogic : ScreenLogic = oldScreen as ScreenLogic
	screenLogic.ScreenExit.emit()
	lastScreen = oldScreen.name
	oldScreen.queue_free()
