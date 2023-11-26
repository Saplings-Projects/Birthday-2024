extends Node2D
class_name GridLogic

const MAX_HEIGHT = 20
const MAX_WIDTH = 20

#have this passed by the level selector in the future
@export var debug_setupData : LevelSetup

var availablePieces : Array[Node2D]

#var 2D array of grid occupancies
var gridSpaces = []
var freeSpaces = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	#double MAX for negative coordinates
	for x in MAX_WIDTH * 2:
		gridSpaces.append([])
		for y in MAX_WIDTH * 2:
			var gridSpaceInfo = GridSpaceInfo.new()
			gridSpaceInfo.currentStatus = GridSpaceStatusEnum.GridSpaceStatus.CLOSED
			gridSpaceInfo.occupyingPiece = null
			gridSpaceInfo.gridPosition = Vector2(x - MAX_WIDTH, y - MAX_HEIGHT)
			gridSpaceInfo.levelGridReference = self
			gridSpaces[x].append(gridSpaceInfo)
	
	SetupLevel(debug_setupData)
	pass

# # Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta):
# 	pass

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

#returns an integer; 0 is empty, 1 is occupied, 2 is blocked or unused
func GetGridSpace(x : int, y : int):
	return gridSpaces[x + MAX_WIDTH][y + MAX_HEIGHT]
	
#0 is empty, 1 is occupied, 2 is blocked or unused
func SetGridSpace(x : int, y : int, newValue : GridSpaceStatusEnum.GridSpaceStatus, occupyingPiece : PieceLogic):
	var gridInfo = gridSpaces[x][y]
	if gridInfo.currentStatus == GridSpaceStatusEnum.GridSpaceStatus.OPEN and newValue != GridSpaceStatusEnum.GridSpaceStatus.OPEN:
		--freeSpaces
		gridInfo.occupyingPiece = occupyingPiece
	elif gridInfo.currentStatus != GridSpaceStatusEnum.GridSpaceStatus.OPEN and newValue == GridSpaceStatusEnum.GridSpaceStatus.OPEN:
		++freeSpaces
		gridInfo.occupyingPiece = null
	gridInfo.currentStatus = newValue
	gridSpaces[x][y] = gridInfo

func PlacePiece(piece : PieceLogic):
	var piecePosition = piece.position
	#check if on grid
		#if not, return false/failure
	
	#map position to a grid coordinate
	
	var squareOffsetsArray = piece.GetPieceShapeOffsetArray()
	for shapeSquare in squareOffsetsArray:
		var offsetXCoord = shapeSquare.x
		var offsetYCoord = shapeSquare.y
		#modify the offset coordinates based on the rotation of the piece
		match piece.currentRotation:
			RotationEnum.Rotation.NONE:
				#do nothing
				pass
			RotationEnum.Rotation.CLOCKWISE90:
				pass
			RotationEnum.Rotation.FLIPPED180:
				pass
			RotationEnum.Rotation.COUNTERWISE90:
				pass
		
		var spaceStatus = GetGridSpace(offsetXCoord, offsetYCoord)
		if spaceStatus != 0:
			return false
	
	#if all squares are legal, place piece
	for shapeSquare in squareOffsetsArray:
		var offsetXCoord = shapeSquare.x
		var offsetYCoord = shapeSquare.y
		#modify the offset coordinates based on the rotation of the piece
		match piece.currentRotation:
			RotationEnum.Rotation.NONE:
				#do nothing
				pass
			RotationEnum.Rotation.CLOCKWISE90:
				pass
			RotationEnum.Rotation.FLIPPED180:
				pass
			RotationEnum.Rotation.COUNTERWISE90:
				pass
		SetGridSpace(offsetXCoord, offsetYCoord, 1, piece)
		
	return true

func RemovePiece(inputPosition : Vector2):
	var offsetXCoord = inputPosition.x
	var offsetYCoord = inputPosition.y
	
	#based on provided position, map to a grid coordinate
	
	pass
