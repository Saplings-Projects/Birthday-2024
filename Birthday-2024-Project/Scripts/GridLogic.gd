extends TileMap
class_name GridLogic

const MAX_HEIGHT : int = 20
const MAX_WIDTH : int = 20
const TILE_ATLAS_OPEN = Vector2i(1, 0)
const DEBUG_TILE_OCCUPIED = Vector2i(2, 0)
const DEBUG_TILE_CLOSED = Vector2i(0, 0)

#have this passed by the level selector in the future
@export var debug_setupData : LevelSetup

var availablePieces : Array[Node2D]
var blockerPieces : Array[Node2D]
var freeSpaces : int = 0
var xMinGrid : int = 0
var xMaxGrid : int = 0
var yMinGrid : int = 0
var yMaxGrid : int = 0

func ClearLevel():
	freeSpaces = 0
	xMinGrid = 0
	xMaxGrid = 0
	yMinGrid = 0
	yMaxGrid = 0
	for x in MAX_WIDTH * 2:
		for y in MAX_WIDTH * 2:
			var gridSpaceInfo : GridSpaceInfo = _gridSpaces[x][y]
			gridSpaceInfo.currentStatus = GridSpaceStatusEnum.GridSpaceStatus.CLOSED
			gridSpaceInfo.occupyingPiece = null
			_gridSpaces[x][y] = gridSpaceInfo
	while availablePieces.size() > 0:
		var piece : Node2D = availablePieces.pop_back()
		piece.queue_free()
	while blockerPieces.size() > 0:
		var piece : Node2D = blockerPieces.pop_back()
		piece.queue_free()

func LoadLevel(levelSetupData : LevelSetup):
	var pieceSetupsData : Array[PieceSetup] = levelSetupData.RetrieveLevelData()
	if pieceSetupsData != null:
		for pieceSetup in pieceSetupsData:
			#look up scene piece via ID
			var scenePiecePrefab = load("res://ScenePrefabs/Pieces/" + pieceSetup.pieceID)
			#instantiate scene piece
			add_child(scenePiecePrefab)
			var scenePiece : Node2D = get_node(pieceSetup.pieceID)
			scenePiece.PieceLogic.SetPieceRotation(pieceSetup.pieceRotation)
			scenePiece.PieceLogic.levelReference = self
			if pieceSetup.isBlocker == false:
				#a locked piece that sits on the grid
				SetGridSpacesByPieceShape(pieceSetup.gridPosition, GridSpaceStatusEnum.GridSpaceStatus.CLOSED, scenePiece)
				blockerPieces.push_back(scenePiece)
			else:
				#open level grid spaces
				SetGridSpacesByPieceShape(pieceSetup.gridPosition, GridSpaceStatusEnum.GridSpaceStatus.OPEN, scenePiece)
				availablePieces.push_back(scenePiece)
			
		#set piece to outskirts of level grid
		#TODO: place more neatly around the grid
		for availablePiece in availablePieces:
			availablePiece.position = GridCoordinateToPosition(Vector2i(xMaxGrid + 3, 0)) #shunting it to the right side

func PositionToGridCoordinate(pos : Vector2) -> Vector2i:
	var xCoord : int = floor(pos.x / self.TileSet.tile_size.x)
	var yCoord : int = floor(pos.y / self.TileSet.tile_size.y)
	return Vector2i(xCoord, yCoord)

func GridCoordinateToPosition(gridCoords : Vector2i) -> Vector2:
	var xPos : int = gridCoords.x 
	var yPos : int = gridCoords.y
	#TODO: Use the tile set pixel size and math to convert
	#self.TileSet.tile_size.x
	return Vector2(xPos, yPos)

func GetGridSpace(gridCoords : Vector2i) -> GridSpaceInfo:
	return _gridSpaces[gridCoords.x + MAX_WIDTH][gridCoords.y + MAX_HEIGHT]
	
func SetGridSpace(gridCoords : Vector2i, newValue : GridSpaceStatusEnum.GridSpaceStatus, occupyingPiece : PieceLogic):
	var gridInfo : GridSpaceInfo = GetGridSpace(gridCoords)
	if gridInfo.currentStatus == GridSpaceStatusEnum.GridSpaceStatus.OPEN and newValue != GridSpaceStatusEnum.GridSpaceStatus.OPEN:
		freeSpaces -= 1
		gridInfo.occupyingPiece = occupyingPiece
	elif gridInfo.currentStatus != GridSpaceStatusEnum.GridSpaceStatus.OPEN and newValue == GridSpaceStatusEnum.GridSpaceStatus.OPEN:
		freeSpaces += 1
		gridInfo.occupyingPiece = null
	gridInfo.currentStatus = newValue
	_gridSpaces[gridCoords.x + MAX_WIDTH][gridCoords.y + MAX_HEIGHT] = gridInfo
	#setup the tile visual on the tilemap
	var SOURCE_ID = 0 #source id?
	var tileAtlasCoord : Vector2i
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
	var shapeOffsets : Array[Vector2i] = piece.GetPieceShapeOffsetArray()
	var translatedCoords : Array[Vector2i] = []
	for squareOffset in shapeOffsets:
		translatedCoords.push_back(Vector2i(gridCoords.x + squareOffset.x, gridCoords.y + squareOffset.y))
	SetMultipleGridSpaces(translatedCoords, newValue, piece)

func CheckLegalToPlace(piece : PieceLogic) -> bool:
	var pieceCoords : Vector2i = PositionToGridCoordinate(piece.GetOriginSquarePosition())
	#if off the grid map
	if pieceCoords.x < xMinGrid or pieceCoords.x > xMaxGrid:
		return false
	if pieceCoords.y < yMinGrid or pieceCoords.y > yMaxGrid:
		return false
	var squareOffsetsArray : Array[Vector2i] = piece.GetPieceShapeOffsetArray()
	for shapeSquare in squareOffsetsArray:
		var spaceStatus : GridSpaceInfo = GetGridSpace(pieceCoords + shapeSquare)
		if spaceStatus.currentStatus != GridSpaceStatusEnum.GridSpaceStatus.OPEN:
			return false
	return true

func PlacePiece(piece : PieceLogic) -> bool:
	if CheckLegalToPlace(piece) == false:
		return false
	var pieceCoords : Vector2i = PositionToGridCoordinate(piece.GetOriginSquarePosition())
	SetGridSpacesByPieceShape(pieceCoords, GridSpaceStatusEnum.GridSpaceStatus.OCCUPIED, piece)
	piece.AssignMapGridCoordinates(pieceCoords)
	#TODO: check win condition HERE
	return true

func RemovePieceByCoordinates(gridCoord : Vector2i) -> GridSpaceInfo:
	var gridInfo : GridSpaceInfo = GetGridSpace(gridCoord)
	if gridInfo.occupyingPiece == null:
		return null
	var piece = gridInfo.occupyingPiece
	SetGridSpacesByPieceShape(PositionToGridCoordinate(piece.GetOriginSquarePosition()), GridSpaceStatusEnum.GridSpaceStatus.OPEN, piece)
	piece.ClearMapGridCoordinates()
	return piece

func RemovePieceByPosition(inputPosition : Vector2) -> GridSpaceInfo:
	var gridPos : Vector2i = PositionToGridCoordinate(inputPosition)
	return RemovePieceByCoordinates(gridPos)

###############################################################################

#var 2D array of grid occupancies
var _gridSpaces : Array = []

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
			var gridSpaceInfo : GridSpaceInfo = GridSpaceInfo.new()
			gridSpaceInfo.currentStatus = GridSpaceStatusEnum.GridSpaceStatus.CLOSED
			gridSpaceInfo.occupyingPiece = null
			gridSpaceInfo.gridPosition = Vector2i(x - MAX_WIDTH, y - MAX_HEIGHT)
			gridSpaceInfo.levelGridReference = self
			_gridSpaces[x].append(gridSpaceInfo)
