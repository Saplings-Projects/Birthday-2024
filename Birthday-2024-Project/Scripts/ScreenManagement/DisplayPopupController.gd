class_name DisplayPopupController
extends TextPopupController

const PIECES_KEY : String = "PIECES_ARRAY_KEY"

@export var pieceDisplay : HBoxContainer

func onScreenEnter():
	var hasPieces : bool = myScreen.transitionData.has(PIECES_KEY)
	var displayPieces : Array[PackedScene] = []
	if hasPieces:
		displayPieces = myScreen.transitionData[PIECES_KEY]
		if displayPieces.size() == 0:
			hasPieces = false
		
	for piece in displayPieces:
		var controlNode : Control = Control.new()
		controlNode.custom_minimum_size.x = 250
		pieceDisplay.add_child(controlNode)
		var pieceClone : Node2D = piece.instantiate() as Node2D
		controlNode.add_child(pieceClone)
		pieceClone.position = Vector2(125, 100)
		pieceClone.scale = Vector2(0.65, 0.65)
		
	super.onScreenEnter()
