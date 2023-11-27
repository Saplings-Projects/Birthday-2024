extends TileMap
class_name GridLogic

const MAX_HEIGHT = 20
const MAX_WIDTH = 20
const TILE_ATLAS_OPEN = Vector2i(1, 0)
const DEBUG_TILE_OCCUPIED = Vector2i(2, 0)
const DEBUG_TILE_CLOSED = Vector2i(0, 0)

#have this passed by the level selector in the future
@export var debug_setupData : LevelSetup

var availablePieces : Array[Node2D]
var freeSpaces = 0
var xMinGrid = 0
var xMaxGrid = 0
var yMinGrid = 0
var yMaxGrid = 0

func LoadLevel(levelSetupData : LevelSetup):
	var pieceSetupsData = levelSetupData.ParseJsonToData() #Array of PieceSetup
	if pieceSetupsData != null:
		for pieceSetup in pieceSetupsData:
			#look up scene piece via ID
			var scenePiecePrefab = load("res://" + pieceSetup.pieceID)
			#instantiate scene piece
			add_child(scenePiecePrefab)
			var scenePiece = get_node(pieceSetup.pieceID)
			scenePiece.PieceLogic.SetPieceRotation(pieceSetup.pieceRotation)
			if pieceSetup.isBlocker:
				#use piece temporarily to undo grid spaces by shape
				SetGridSpacesByPieceShape(pieceSetup.gridPosition, GridSpaceStatusEnum.GridSpaceStatus.CLOSED, scenePiece)
				scenePiece.queue_free()
			else:
				scenePiece.PieceLogic.levelReference = self
				#add instantiated piece to availablePieces
				availablePieces.push_back(scenePiece)
				#add to level grid spaces
				SetGridSpacesByPieceShape(pieceSetup.gridPosition, GridSpaceStatusEnum.GridSpaceStatus.OPEN, scenePiece)
			
		#set piece to outskirts of level grid
		#TODO: place more neatly around the grid
		for availablePiece in availablePieces:
			availablePiece.position = GridCoordinateToPosition(Vector2i(xMaxGrid + 3, 0)) #shunting it to the right side

func PositionToGridCoordinate(pos : Vector2):
	var xCoord = pos.x
	var yCoord = pos.y
	#TODO: Use the tile set pixel size and math to convert
	#self.TileSet.tile_size.x
	return Vector2i(int(xCoord), int(yCoord))

func GridCoordinateToPosition(gridCoords : Vector2i):
	var xPos = gridCoords.x
	var yPos = gridCoords.y
	#TODO: Use the tile set pixel size and math to convert
	#self.TileSet.tile_size.x
	return Vector2(xPos, yPos)

#returns an integer; 0 is empty, 1 is occupied, 2 is blocked or unused
func GetGridSpace(gridCoords : Vector2i):
	return _gridSpaces[gridCoords.x + MAX_WIDTH][gridCoords.y + MAX_HEIGHT]
	
#0 is empty, 1 is occupied, 2 is blocked or unused
func SetGridSpace(gridCoords : Vector2i, newValue : GridSpaceStatusEnum.GridSpaceStatus, occupyingPiece : PieceLogic):
	var gridInfo = GetGridSpace(gridCoords)
	if gridInfo.currentStatus == GridSpaceStatusEnum.GridSpaceStatus.OPEN and newValue != GridSpaceStatusEnum.GridSpaceStatus.OPEN:
		freeSpaces -= 1
		gridInfo.occupyingPiece = occupyingPiece
	elif gridInfo.currentStatus != GridSpaceStatusEnum.GridSpaceStatus.OPEN and newValue == GridSpaceStatusEnum.GridSpaceStatus.OPEN:
		freeSpaces += 1
		gridInfo.occupyingPiece = null
	gridInfo.currentStatus = newValue
	_gridSpaces[gridCoords.x + MAX_WIDTH][gridCoords.y + MAX_HEIGHT] = gridInfo
	#source id?
	var SOURCE_ID = 0
	var tileAtlasCoord
	match newValue:
		GridSpaceStatusEnum.GridSpaceStatus.OPEN:
			tileAtlasCoord = TILE_ATLAS_OPEN
		GridSpaceStatusEnum.GridSpaceStatus.OCCUPIED:
			tileAtlasCoord = DEBUG_TILE_OCCUPIED
		GridSpaceStatusEnum.GridSpaceStatus.CLOSED:
			tileAtlasCoord = DEBUG_TILE_CLOSED
	self.set_cell(0, GridCoordinateToPosition(gridCoords), SOURCE_ID, tileAtlasCoord)
	
func SetMultipleGridSpaces(gridCoordinates : Array[Vector2i], newValue : GridSpaceStatusEnum.GridSpaceStatus, occupyingPiece : PieceLogic):
	for gridCoords in gridCoordinates:
		SetGridSpace(gridCoords, newValue, occupyingPiece)

func SetGridSpacesByPieceShape(gridCoords : Vector2i, newValue : GridSpaceStatusEnum.GridSpaceStatus, piece : PieceLogic):
	var shapeOffsets = piece.GetPieceShapeOffsetArray()
	var translatedCoords = []
	for squareOffset in shapeOffsets:
		translatedCoords.push_back(Vector2i(squareOffset.x + gridCoords.x, squareOffset.y + gridCoords.y))
	SetMultipleGridSpaces(translatedCoords, newValue, piece)

func CheckLegalToPlace(piece : PieceLogic):
	var pieceCoords = PositionToGridCoordinate(piece.GetOriginSquarePosition())
	#if off the grid map
	if pieceCoords.x < xMinGrid or pieceCoords.x > xMaxGrid:
		return false
	if pieceCoords.y < yMinGrid or pieceCoords.y > yMaxGrid:
		return false
	var squareOffsetsArray = piece.GetPieceShapeOffsetArray()
	for shapeSquare in squareOffsetsArray:
		var spaceStatus = GetGridSpace(pieceCoords + shapeSquare)
		if spaceStatus != GridSpaceStatusEnum.GridSpaceStatus.OPEN:
			return false
	return true

func PlacePiece(piece : PieceLogic):
	if CheckLegalToPlace(piece) == false:
		return false
	var pieceCoords = PositionToGridCoordinate(piece.GetOriginSquarePosition())
	SetGridSpacesByPieceShape(pieceCoords, GridSpaceStatusEnum.GridSpaceStatus.OCCUPIED, piece)
	piece.AssignMapGridCoordinates(pieceCoords)
	#TODO: check win condition HERE
	return true

func RemovePieceByCoordinates(gridCoord : Vector2i):
	var gridInfo = GetGridSpace(gridCoord)
	if gridInfo.occupyingPiece == null:
		return null
	var piece = gridInfo.occupyingPiece
	SetGridSpacesByPieceShape(PositionToGridCoordinate(piece.GetOriginSquarePosition()), GridSpaceStatusEnum.GridSpaceStatus.OPEN, piece)
	piece.ClearMapGridCoordinates()
	return piece

func RemovePieceByPosition(inputPosition : Vector2):
	var gridPos = PositionToGridCoordinate(inputPosition)
	return RemovePieceByCoordinates(gridPos)

###############################################################################

#var 2D array of grid occupancies
var _gridSpaces = []

# Called when the node enters the scene tree for the first time.
func _ready():
	_SetupLevel()
	#TODO: Load level using Level Select
	LoadLevel(debug_setupData)

# # Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta):
# 	pass

#setup level based on setupData
func _SetupLevel():
	#Setup grid, double MAX for negative coordinates
	for x in MAX_WIDTH * 2:
		_gridSpaces.append([])
		for y in MAX_WIDTH * 2:
			var gridSpaceInfo = GridSpaceInfo.new()
			gridSpaceInfo.currentStatus = GridSpaceStatusEnum.GridSpaceStatus.CLOSED
			gridSpaceInfo.occupyingPiece = null
			gridSpaceInfo.gridPosition = Vector2i(x - MAX_WIDTH, y - MAX_HEIGHT)
			gridSpaceInfo.levelGridReference = self
			_gridSpaces[x].append(gridSpaceInfo)
