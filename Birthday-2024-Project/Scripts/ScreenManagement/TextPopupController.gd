class_name TextPopupController
extends Node

@export var myScreen : ScreenLogic
@export var titleText : Label
@export var bodyText : Label
@export var animator : AnimationPlayer

func onScreenEnter():
	titleText.text = myScreen.transitionData[ScreenManager.TITLE_KEY]
	bodyText.text = myScreen.transitionData[ScreenManager.BODY_KEY]
	animator.play("PopupAnimations/Enter")
	
func OnClose():
	animator.play("PopupAnimations/Exit")
	await animator.animation_finished
	myScreen.ClosePopup({})
