class_name ScreenLogic
extends Node

signal ScreenEnter
signal ScreenExit

@export var clearScreenStack : bool = true

var screenManager : ScreenManager
var transitionData : Dictionary

func ClosePopup(data : Dictionary):
	screenManager.CloseTopScreen(data)
	
func ClosePopupBySignal():
	screenManager.CloseTopScreen({})

func GoToScreen(screen : PackedScene, data : Dictionary):
	screenManager.GoToScreen(screen, data)

func ShowSettings():
	screenManager.ShowSettings()

func ShowConfirmationPopup(title : String, body : String, confirm : String = "OK", cancel : String = "Cancel"):
	screenManager.ShowConfirmationPopup(title, body, confirm, cancel)

func ExitApplication():
	ScreenEnter.connect(ExitConfirmation)
	ShowConfirmationPopup("Quit?", "Are you sure you want to quit?", "Yes", "No")
	
func ExitConfirmation():
	#if yes
	if transitionData[ConfirmationPopupController.RESPONSE_KEY] == true:
		get_tree().quit()
	
	#if no, do nothing
	ScreenEnter.disconnect(ExitConfirmation)
