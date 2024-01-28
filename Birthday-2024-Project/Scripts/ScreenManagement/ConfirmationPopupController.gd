class_name ConfirmationPopupController
extends Node

const RESPONSE_KEY : String = "CONFIRMATION_POPUP_RESPONSE"
const TITLE_KEY : String = "CONFIRMATION_POPUP_TITLE"
const BODY_KEY : String = "CONFIRMATION_POPUP_BODY"
const CONFIRM_KEY : String = "CONFIRMATION_POPUP_CONFIRM"
const CANCEL_KEY : String = "CONFIRMATION_POPUP_CANCEL"

@export var myScreen : ScreenLogic
@export var titleText : Label
@export var bodyText : Label
@export var confirmButtonText : Label
@export var cancelButtonText : Label

func onScreenEnter():
	titleText.text = myScreen.transitionData[TITLE_KEY] as String
	bodyText.text = myScreen.transitionData[BODY_KEY]
	confirmButtonText.text = myScreen.transitionData[CONFIRM_KEY]
	cancelButtonText.text = myScreen.transitionData[CANCEL_KEY]

func onConfirm():
	var data : Dictionary = {}
	data[RESPONSE_KEY] = true
	myScreen.ClosePopup(data)

func onCancel():
	var data : Dictionary = {}
	data[RESPONSE_KEY] = false
	myScreen.ClosePopup(data)
