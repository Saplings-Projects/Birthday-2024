class_name LibraryPiece
extends TextureButton

@export var puzzleUiManager : PuzzleUiManager

func DebugPress():
	puzzleUiManager.controller.spawn_piece(get_child(0).name)
	print("DEBUG: press")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
