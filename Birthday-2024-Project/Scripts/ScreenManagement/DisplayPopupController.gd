class_name DisplayPopupController
extends Node

const PIECES_KEY : String = "PIECES_ARRAY_KEY"

@export var myScreen : ScreenLogic
@export var titleText : Label
@export var bodyText : Label
@export var pieceDisplay : HBoxContainer
@export var animator : AnimationPlayer

func onScreenEnter():
	titleText.text = myScreen.transitionData[ScreenManager.TITLE_KEY]
	var hasPieces : bool = myScreen.transitionData.has(PIECES_KEY)
	var displayPieces : Array[PackedScene]
	if hasPieces:
		displayPieces = myScreen.transitionData[PIECES_KEY]
		if displayPieces.size() == 0:
			hasPieces = false
	
	bodyText.text = myScreen.transitionData[ScreenManager.BODY_KEY]
		
	for piece in displayPieces:
		var controlNode : Control = Control.new()
		controlNode.custom_minimum_size.x = 300
		pieceDisplay.add_child(controlNode)
		var pieceClone : Node2D = piece.instantiate() as Node2D
		controlNode.add_child(pieceClone)
		pieceClone.position = Vector2(150, 100)
		
	animator.play("PopupAnimations/Enter")
	
func OnClose():
	animator.play("PopupAnimations/Exit")
	await animator.animation_finished
	myScreen.ClosePopup({})
