class_name LibraryPiece
extends TextureButton

@export var puzzleUiManager : PuzzleUiManager

func GrabPiece():
	puzzleUiManager.controller.spawn_piece(get_child(0).name)
