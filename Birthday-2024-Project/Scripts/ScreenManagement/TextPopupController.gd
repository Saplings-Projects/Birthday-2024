class_name TextPopupController
extends Node

const TITLE_KEY : String = "POPUP_TITLE"
const BODY_KEY : String = "POPUP_BODY"
const CONFIRM_KEY : String = "POPUP_CONFIRM"

@export var myScreen : ScreenLogic
@export var titleText : Label
@export var bodyText : Label
@export var confirmButtonText : Button
@export var animator : AnimationPlayer

func onScreenEnter():
	titleText.text = myScreen.transitionData[TITLE_KEY]
	bodyText.text = myScreen.transitionData[BODY_KEY]
	confirmButtonText.text = myScreen.transitionData[CONFIRM_KEY]
	animator.play("PopupAnimations/Enter")

func onClose():
	animator.play("PopupAnimations/Exit")
	await animator.animation_finished
	myScreen.ClosePopup()
