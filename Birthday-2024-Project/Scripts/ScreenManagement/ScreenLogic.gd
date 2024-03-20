class_name ScreenLogic
extends Node

signal ScreenEnter
signal ScreenExit

@export var clearScreenStack : bool = true

var screenManager : ScreenManager
var transitionData : Dictionary

func ClosePopup():
	screenManager.CloseTopScreen(transitionData)

func GoToScreen(screen : PackedScene, data : Dictionary, transitionStyle : ScreenManager.TransitionStyle):
	screenManager.GoToScreen(screen, data, transitionStyle)

func ShowSettings():
	screenManager.ShowSettings(transitionData)

func ShowTextPopup(title : String, body : String, confirm : String = "Close"):
	screenManager.ShowTextPopup(title, body, transitionData, confirm)

func ShowConfirmationPopup(title : String, body : String, confirm : String = "OK", cancel : String = "Cancel"):
	screenManager.ShowConfirmationPopup(title, body, transitionData, confirm, cancel)

func ShowDisplayPopup(title : String, body : String, displayPieces : Array[PackedScene], confirm : String = "Close"):
	screenManager.ShowDisplayPopup(title, body, displayPieces, transitionData, confirm)

func ExitApplication():
	ScreenEnter.connect(ExitConfirmation)
	ShowConfirmationPopup("Quit", "Close the game and return to desktop?", "Yes", "No")
	
func ExitConfirmation():
	#if yes
	if transitionData[ConfirmationPopupController.RESPONSE_KEY] == true:
		get_tree().quit()
	
	#if no, do nothing
	ScreenEnter.disconnect(ExitConfirmation)
