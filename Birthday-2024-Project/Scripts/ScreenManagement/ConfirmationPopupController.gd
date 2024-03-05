class_name ConfirmationPopupController
extends Node

const RESPONSE_KEY : String = "CONFIRMATION_POPUP_RESPONSE"
const CANCEL_KEY : String = "CONFIRMATION_POPUP_CANCEL"

@export var myScreen : ScreenLogic
@export var titleText : Label
@export var bodyText : Label
@export var confirmButtonText : Button
@export var cancelButtonText : Button
@export var animator : AnimationPlayer

func onScreenEnter():
	titleText.text = myScreen.transitionData[ScreenManager.TITLE_KEY] as String
	bodyText.text = myScreen.transitionData[ScreenManager.BODY_KEY]
	confirmButtonText.text = myScreen.transitionData[ScreenManager.CONFIRM_KEY]
	cancelButtonText.text = myScreen.transitionData[CANCEL_KEY]
	animator.play("PopupAnimations/Enter")

func onConfirm():
	var data : Dictionary = {}
	data[RESPONSE_KEY] = true
	_Close(data)

func onCancel():
	var data : Dictionary = {}
	data[RESPONSE_KEY] = false
	_Close(data)
	
func _Close(data : Dictionary):
	animator.play("PopupAnimations/Exit")
	await animator.animation_finished
	myScreen.ClosePopup(data)
	
