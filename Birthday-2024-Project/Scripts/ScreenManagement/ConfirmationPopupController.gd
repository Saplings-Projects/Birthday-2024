class_name ConfirmationPopupController
extends TextPopupController

const RESPONSE_KEY : String = "CONFIRMATION_POPUP_RESPONSE"
const CANCEL_KEY : String = "CONFIRMATION_POPUP_CANCEL"

@export var cancelButtonText : Button

func onScreenEnter():
	cancelButtonText.text = myScreen.transitionData[CANCEL_KEY]
	super.onScreenEnter()

func onConfirm():
	myScreen.transitionData[RESPONSE_KEY] = true
	onClose()

func onCancel():
	myScreen.transitionData[RESPONSE_KEY] = false
	onClose()
