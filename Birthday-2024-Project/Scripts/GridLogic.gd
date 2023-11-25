extends Node2D

#have this passed by the level selector in the future
@export var debug_setupData : LevelSetup

var availablePieces : Array[Node2D]

#var 2D array of grid occupancies

# Called when the node enters the scene tree for the first time.
func _ready():
	SetupLevel(debug_setupData)
	pass

#setup level based on setupData
func SetupLevel(levelSetupData : LevelSetup):
	var pieceSetupData = levelSetupData.ParseJsonToData()
	if pieceSetupData != null:
		for pieceSetup in pieceSetupData:
			#look up scene piece via ID
			var scenePiece = load("res://" + pieceSetup.pieceID)
			#instantiate scene piece
			add_child(scenePiece)
			#add piece to availablePieces
			availablePieces.push_back(get_node(pieceSetup.pieceID))
			#add to level grid spaces
			
		# for availablePiece in availablePieces:
		# 	#set piece to outskirts of level grid
	pass

# # Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta):
# 	pass
