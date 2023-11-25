extends Node2D

@export var setupData : LevelSetup

var availablePieces : Array[PieceLogic]

#var 2D array of grid occupancies

# Called when the node enters the scene tree for the first time.
func _ready():
	SetupLevel()
	pass

func SetupLevel():
	#setup level based on setupData
	pass

# # Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta):
# 	pass
