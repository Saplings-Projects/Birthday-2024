extends TileMap
class_name GridLogic

const MAX_HEIGHT : int = 20
const MAX_WIDTH : int = 20
const TILE_ATLAS_OPEN = Vector2i(1, 0)
const TILE_ATLAS_OCCUPIED = Vector2i(2, 0)
const TILE_ATLAS_CLOSED = Vector2i(0, 0)

enum GridSpaceStatus {
	OPEN,
	OCCUPIED,
	CLOSED #blocked or unused
}

@export var startingPositions : Array[Vector2i]

var availablePieces : Array[Node2D]
var blockerPieces : Array[Node2D]
var freeSpaces : int = 0
var xMinGrid : int = 0
var xMaxGrid : int = 0
var yMinGrid : int = 0
var yMaxGrid : int = 0

signal grid_updated


func ClearLevel():
	freeSpaces = 0
	xMinGrid = 0
	xMaxGrid = 0
	yMinGrid = 0
	yMaxGrid = 0
	for x in MAX_WIDTH * 2:
		for y in MAX_WIDTH * 2:
			var gridSpaceInfo : GridSpaceInfo = _gridSpaces[x][y]
			gridSpaceInfo.currentStatus = GridSpaceInfo.GridSpaceStatus.CLOSED
			gridSpaceInfo.occupyingPiece = null
			_gridSpaces[x][y] = gridSpaceInfo
	while availablePieces.size() > 0:
		var piece : Node2D = availablePieces.pop_back()
		piece.queue_free()
	while blockerPieces.size() > 0:
		var piece : Node2D = blockerPieces.pop_back()
		piece.queue_free()

func LoadLevel(levelSetupData : LevelSetup):
	ClearLevel()
	
	var pieceSetupsData : Array[PieceSetup] = levelSetupData.RetrieveLevelData()
	if pieceSetupsData.size() > 0:
		for pieceSetup in pieceSetupsData:
			#look up scene piece via ID
			var scenePiecePrefab = load("res://ScenePrefabs/Pieces/" + pieceSetup.pieceID + ".tscn")
			#instantiate scene piece
			var scenePiece = scenePiecePrefab.instantiate()
			add_child(scenePiece)
			var pieceLogic : PieceLogic = scenePiece as PieceLogic
			pieceLogic.levelGridReference = self
			pieceLogic._initialize()
			pieceLogic.SetPieceRotation(pieceSetup.pieceRotation)
			if pieceSetup.isBlocker:
				#a locked piece that sits on the grid
				SetGridSpacesByPieceShape(pieceSetup.gridPosition, GridSpaceInfo.GridSpaceStatus.CLOSED, pieceLogic)
				blockerPieces.push_back(scenePiece)
			else:
				#open level grid spaces
				SetGridSpacesByPieceShape(pieceSetup.gridPosition, GridSpaceInfo.GridSpaceStatus.OPEN, pieceLogic)
				availablePieces.push_back(scenePiece)
		
		#center grid map based on the width and height
		var midPoint : Vector2i = _GridCoordinateToPosition(Vector2i(xMaxGrid, yMaxGrid)) + _GridCoordinateToPosition(Vector2i(xMinGrid, yMinGrid))
		global_position = midPoint * -0.5
		
		#set piece to outskirts of level grid and unrotate
		#TODO: place more neatly around the grid
		var iter = 0
		for availablePiece in availablePieces:
			availablePiece.global_position = GridCoordinateToPosition(startingPositions[iter]) #shunting it to the right side
			(availablePiece as PieceLogic).SetPieceRotation(PieceLogic.RotationStates.DEG_0)
			(availablePiece as PieceLogic)._SetReturnPoint()
			iter += 1

func PositionToGridCoordinate(pos : Vector2) -> Vector2i:
	#adjust the position provided by how the grid is offset for centering
	pos -= global_position
	var xCoord : int = floor(pos.x / tile_set.tile_size.x)
	var yCoord : int = floor(pos.y / tile_set.tile_size.y)
	return Vector2i(xCoord, yCoord)

func GridCoordinateToPosition(gridCoords : Vector2i) -> Vector2:
	#account for grid offset due to centering
	return _GridCoordinateToPosition(gridCoords) + global_position


func get_free_spaces() -> int:
	return freeSpaces


func GetGridSpace(gridCoords : Vector2i) -> GridSpaceInfo:
	return _gridSpaces[gridCoords.x + MAX_WIDTH][gridCoords.y + MAX_HEIGHT]
	
func SetGridSpace(gridCoords : Vector2i, newValue : GridSpaceInfo.GridSpaceStatus, occupyingPiece : PieceLogic):
	var gridInfo : GridSpaceInfo = GetGridSpace(gridCoords)
	if gridInfo.currentStatus == GridSpaceInfo.GridSpaceStatus.OPEN and newValue != GridSpaceInfo.GridSpaceStatus.OPEN:
		freeSpaces -= 1
		gridInfo.occupyingPiece = occupyingPiece
	elif gridInfo.currentStatus != GridSpaceInfo.GridSpaceStatus.OPEN and newValue == GridSpaceInfo.GridSpaceStatus.OPEN:
		freeSpaces += 1
		gridInfo.occupyingPiece = null
	gridInfo.currentStatus = newValue
	_gridSpaces[gridCoords.x + MAX_WIDTH][gridCoords.y + MAX_HEIGHT] = gridInfo
	#setup the tile visual on the tilemap
	var SOURCE_ID = 0
	var tileAtlasCoord : Vector2i
	match newValue:
		GridSpaceInfo.GridSpaceStatus.OPEN:
			tileAtlasCoord = TILE_ATLAS_OPEN
			if gridCoords.x < xMinGrid:
				xMinGrid = gridCoords.x
			if gridCoords.x > xMaxGrid:
				xMaxGrid = gridCoords.x
			if gridCoords.y < yMinGrid:
				yMinGrid = gridCoords.y
			if gridCoords.y > yMaxGrid:
				yMaxGrid = gridCoords.y
		GridSpaceInfo.GridSpaceStatus.OCCUPIED:
			tileAtlasCoord = TILE_ATLAS_OCCUPIED
		GridSpaceInfo.GridSpaceStatus.CLOSED:
			tileAtlasCoord = TILE_ATLAS_CLOSED
	self.set_cell(0, Vector2i(gridCoords.x, gridCoords.y), SOURCE_ID, tileAtlasCoord)
	
func SetMultipleGridSpaces(gridCoordinates : Array[Vector2i], newValue : GridSpaceInfo.GridSpaceStatus, occupyingPiece : PieceLogic):
	for gridCoords in gridCoordinates:
		SetGridSpace(gridCoords, newValue, occupyingPiece)

func SetGridSpacesByPieceShape(gridCoords : Vector2i, newValue : GridSpaceInfo.GridSpaceStatus, piece : PieceLogic):
	var shapeOffsets : Array[Vector2i] = piece.GetPieceShapeOffsetArray()
	var translatedCoords : Array[Vector2i] = []
	for cellOffset in shapeOffsets:
		translatedCoords.push_back(Vector2i(gridCoords.x + cellOffset.x, gridCoords.y + cellOffset.y))
	SetMultipleGridSpaces(translatedCoords, newValue, piece)

func CheckLegalToPlace(piece : PieceLogic) -> bool:
	var pieceCoords : Vector2i = PositionToGridCoordinate(piece.GetOriginCellPosition())
	#if off the grid map
	if pieceCoords.x < xMinGrid or pieceCoords.x > xMaxGrid:
		return false
	if pieceCoords.y < yMinGrid or pieceCoords.y > yMaxGrid:
		return false
	var cellOffsetsArray : Array[Vector2i] = piece.GetPieceShapeOffsetArray()
	for shapeCell in cellOffsetsArray:
		var spaceStatus : GridSpaceInfo = GetGridSpace(pieceCoords + shapeCell)
		if spaceStatus.currentStatus != GridSpaceInfo.GridSpaceStatus.OPEN:
			return false
	return true

func PlacePiece(piece : PieceLogic) -> bool:
	if CheckLegalToPlace(piece) == false:
		return false
	var pieceCoords : Vector2i = PositionToGridCoordinate(piece.GetOriginCellPosition())
	## REMOVE AFTER DEBUG
	print(pieceCoords)
	SetGridSpacesByPieceShape(pieceCoords, GridSpaceInfo.GridSpaceStatus.OCCUPIED, piece)
	piece.AssignMapGridCoordinates(pieceCoords)
	
	grid_updated.emit()
	
	return true

func RemovePieceByCoordinates(gridCoord : Vector2i) -> PieceLogic:
	var gridInfo : GridSpaceInfo = GetGridSpace(gridCoord)
	if gridInfo.occupyingPiece == null:
		return null
	var piece = gridInfo.occupyingPiece
	SetGridSpacesByPieceShape(PositionToGridCoordinate(piece.GetOriginCellPosition()), GridSpaceInfo.GridSpaceStatus.OPEN, piece)
	piece.return_piece()
	return piece

func RemovePieceByPosition(inputPosition : Vector2) -> PieceLogic:
	var gridPos : Vector2i = PositionToGridCoordinate(inputPosition)
	return RemovePieceByCoordinates(gridPos)

###############################################################################

#var 2D array of grid occupancies
var _gridSpaces : Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	#Setup grid, double MAX for negative coordinates
	for x in MAX_WIDTH * 2:
		_gridSpaces.append([])
		for y in MAX_WIDTH * 2:
			var gridSpaceInfo : GridSpaceInfo = GridSpaceInfo.new()
			gridSpaceInfo.currentStatus = GridSpaceInfo.GridSpaceStatus.CLOSED
			gridSpaceInfo.occupyingPiece = null
			gridSpaceInfo.gridPosition = Vector2i(x - MAX_WIDTH, y - MAX_HEIGHT)
			gridSpaceInfo.levelGridReference = self
			_gridSpaces[x].append(gridSpaceInfo)

func _GridCoordinateToPosition(gridCoords : Vector2i) -> Vector2:
	var xPos : float = gridCoords.x * tile_set.tile_size.x + tile_set.tile_size.x * 0.5
	var yPos : float = gridCoords.y * tile_set.tile_size.y + tile_set.tile_size.y * 0.5
	return Vector2(xPos, yPos)
