extends TileMap
class_name GridLogic

const MAX_HEIGHT : int = 4 #doubled for negative
const MAX_WIDTH : int = 5 #doubled for negative
const TILE_ATLAS_OPEN = Vector2i(1, 0)
const TILE_ATLAS_OCCUPIED = Vector2i(1, 0)
const TILE_ATLAS_CLOSED = Vector2i(0, 0)
const TILE_ATLAS_CLOSED_VISIBLE = Vector2i(2, 0)
const SAFE_HEIGHT : int = 4 #doubled for negative
const SAFE_WIDTH : int = 7 #doubled for negative

const GridSpaceInfo = preload("res://Scripts/GridSpaceInfo.gd")

enum GridMode {
	PLAY,
	EDIT
}

@export var gameManager : GameManager
@export var gridCenterOffset : Vector2
@export var startingPositions : Array[Vector2i]

var availablePieces : Array[PieceLogic]
var blockerPieces : Array[PieceLogic]
var freeSpaces : int = 0
var xMinGrid : int = 0
var xMaxGrid : int = 0
var yMinGrid : int = 0
var yMaxGrid : int = 0
var gridMode : GridMode

var _levelData : LevelSetup

signal grid_updated

func SetMode(mode : GridMode):
	gridMode = mode

func ClearLevel():
	for x in MAX_WIDTH * 2:
		for y in MAX_HEIGHT * 2:
			SetGridSpace(Vector2i(x - MAX_WIDTH, y - MAX_HEIGHT), GridSpaceInfo.GridSpaceStatus.CLOSED, null)
	while availablePieces.size() > 0:
		availablePieces.pop_back().queue_free()
	while blockerPieces.size() > 0:
		blockerPieces.pop_back().queue_free()
	freeSpaces = 0
	xMinGrid = 0
	xMaxGrid = 0
	yMinGrid = 0
	yMaxGrid = 0
	global_position = gridCenterOffset

func ImportLevel(jsonImportData : String):
	var levelSetup : LevelSetup = LevelSetup.new()
	levelSetup.jsonData = jsonImportData
	LoadLevel(levelSetup)
	
func ReloadLevel():
	if _levelData == null:
		ClearLevel()
	else:
		LoadLevel(_levelData)

func LoadLevel(levelSetupData : LevelSetup):
	ClearLevel()
	_levelData = levelSetupData
	
	var pieceSetupsData : Array[PieceSetup] = levelSetupData.RetrieveLevelData()
	if pieceSetupsData.size() > 0:
		for pieceSetup in pieceSetupsData:
			var pieceLogic : PieceLogic = LoadPiece(pieceSetup.pieceID)
			pieceLogic.SetPieceRotation(pieceSetup.pieceRotation)
			pieceLogic.RecordGridPosition(pieceSetup.gridPosition)
			if pieceLogic.isBlocker:
				#a locked piece that sits on the grid
				SetGridSpacesByPieceShape(pieceSetup.gridPosition, GridSpaceInfo.GridSpaceStatus.CLOSED, pieceLogic)
				pieceLogic.return_piece(true)
			else:
				#open level grid spaces
				SetGridSpacesByPieceShape(pieceSetup.gridPosition, GridSpaceInfo.GridSpaceStatus.OPEN, pieceLogic)
		
		#center grid map based on the width and height
		var midPoint : Vector2i = _GridCoordinateToPosition(Vector2i(xMaxGrid, yMaxGrid)) + _GridCoordinateToPosition(Vector2i(xMinGrid, yMinGrid))
		global_position = midPoint * -0.5 + gridCenterOffset
		
		if(gridMode == GridMode.PLAY):
			var rng : RandomNumberGenerator = RandomNumberGenerator.new()
			var quadrant : int = 0
			#set piece to outskirts of level grid and unrotate
			var startingPos : Vector2i
			for availablePiece in availablePieces:
				match quadrant:
					0:
						startingPos.x = xMinGrid - 2
						startingPos.y = rng.randi_range(1, SAFE_HEIGHT - 2)
					1:
						startingPos.x = xMaxGrid + 2
						startingPos.y = rng.randi_range(1, SAFE_HEIGHT - 2)
					2:
						startingPos.x = xMinGrid - 2
						startingPos.y = rng.randi_range(-SAFE_HEIGHT + 1, -1)
					3:
						startingPos.x = xMaxGrid + 2
						startingPos.y = rng.randi_range(-SAFE_HEIGHT + 1, -1)
						quadrant = -1
				
				quadrant += 1
				availablePiece.global_position = GridCoordinateToPosition(startingPos)
				availablePiece.SetPieceRotation(PieceLogic.RotationStates.DEG_0)
				availablePiece._SetReturnPoint()
		else:
			global_position = gridCenterOffset
			for availablePiece in availablePieces:
				availablePiece.return_piece(true)

func LoadPiece(pieceID : String) -> PieceLogic:
	#look up scene piece via ID
	var scenePiecePrefab = load("res://ScenePrefabs/Pieces/" + pieceID + ".tscn")
	#instantiate scene piece
	var scenePiece = scenePiecePrefab.instantiate()
	add_child(scenePiece)
	var pieceLogic : PieceLogic = scenePiece as PieceLogic
	pieceLogic.levelGridReference = self
	pieceLogic.game_manager = gameManager
	pieceLogic._initialize()
	pieceLogic.piece_id = pieceID
	pieceLogic.SetPieceRotation(PieceLogic.RotationStates.DEG_0)
	if pieceLogic.isBlocker:
		blockerPieces.push_back(pieceLogic)
	else:
		availablePieces.push_back(pieceLogic)
	return pieceLogic

func DeletePiece(piece : PieceLogic):
	availablePieces.erase(piece)
	blockerPieces.erase(piece)
	piece.queue_free()

func ExportLevel() -> String:
	var pieceData : Array[String]
	
	for pieceLogic in availablePieces:
		var pieceSetup : PieceSetup = PieceSetup.new()
		pieceSetup.pieceID = pieceLogic.piece_id
		pieceSetup.gridPosition = pieceLogic.placed_grid_position
		pieceSetup.pieceRotation = pieceLogic.current_rotation_state
		pieceData.push_back(pieceSetup.JsonSerialize())
	
	for pieceLogic in blockerPieces:
		var pieceSetup : PieceSetup = PieceSetup.new()
		pieceSetup.pieceID = pieceLogic.piece_id
		pieceSetup.gridPosition = pieceLogic.placed_grid_position
		pieceSetup.pieceRotation = pieceLogic.current_rotation_state
		pieceData.push_back(pieceSetup.JsonSerialize())
		
	return JSON.stringify(pieceData)

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
	if gridCoords.x < -MAX_WIDTH or gridCoords.x >= MAX_WIDTH:
		#printerr("ERROR: attempting to access grid space out of bounds")
		return null
	if gridCoords.y < -MAX_HEIGHT or gridCoords.y >= MAX_HEIGHT:
		#printerr("ERROR: attempting to access grid space out of bounds")
		return null
	return _gridSpaces[gridCoords.x + MAX_WIDTH][gridCoords.y + MAX_HEIGHT]
	
func SetGridSpace(gridCoords : Vector2i, newValue : GridSpaceInfo.GridSpaceStatus, occupyingPiece : PieceLogic):
	var gridInfo : GridSpaceInfo = GetGridSpace(gridCoords)
	#tried accessing an illegal coordinate
	if gridInfo == null:
		return
	if gridInfo.currentStatus == GridSpaceInfo.GridSpaceStatus.OPEN and newValue != GridSpaceInfo.GridSpaceStatus.OPEN:
		freeSpaces -= 1
	elif gridInfo.currentStatus != GridSpaceInfo.GridSpaceStatus.OPEN and newValue == GridSpaceInfo.GridSpaceStatus.OPEN:
		freeSpaces += 1
	gridInfo.currentStatus = newValue
	gridInfo.occupyingPiece = occupyingPiece
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
			if gridMode == GridMode.PLAY:
				tileAtlasCoord = TILE_ATLAS_OCCUPIED
			else:
				tileAtlasCoord = TILE_ATLAS_OPEN
		GridSpaceInfo.GridSpaceStatus.CLOSED:
			if gridMode == GridMode.PLAY:
				tileAtlasCoord = TILE_ATLAS_CLOSED
			else:
				tileAtlasCoord = TILE_ATLAS_CLOSED_VISIBLE
				
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
	
	#if outside the level bounding box
	if gridMode == GridMode.PLAY:
		if pieceCoords.x < xMinGrid or pieceCoords.x > xMaxGrid:
			return false
		if pieceCoords.y < yMinGrid or pieceCoords.y > yMaxGrid:
			return false
	
	var cellOffsetsArray : Array[Vector2i] = piece.GetPieceShapeOffsetArray()
	for shapeCell in cellOffsetsArray:
		var spaceStatus : GridSpaceInfo = GetGridSpace(pieceCoords + shapeCell)
		#would go out of max bounds
		if spaceStatus == null:
			return false
		if gridMode == GridMode.PLAY:
			if spaceStatus.currentStatus != GridSpaceInfo.GridSpaceStatus.OPEN:
				return false
		else:
			if spaceStatus.currentStatus == GridSpaceInfo.GridSpaceStatus.OCCUPIED:
				return false
	return true

func CheckIfInDeletionZone(piece : PieceLogic) -> bool:
	var pieceCoords : Vector2i = PositionToGridCoordinate(piece.GetOriginCellPosition())
	var cellOffsetsArray : Array[Vector2i] = piece.GetPieceShapeOffsetArray()
	for shapeCell in cellOffsetsArray:
		var spaceStatus : GridSpaceInfo = GetGridSpace(pieceCoords + shapeCell)
		#is out of max bounds
		if spaceStatus != null:
			return false
	#all squares are outside the grid map
	return true

func CheckIfOffGrid(piece : PieceLogic) -> bool:
	var pieceCoords : Vector2i = PositionToGridCoordinate(piece.GetOriginCellPosition())
	var cellOffsetsArray : Array[Vector2i] = piece.GetPieceShapeOffsetArray()
	for shapeCell in cellOffsetsArray:
		var spaceStatus : GridSpaceInfo = GetGridSpace(pieceCoords + shapeCell)
		#is out of max bounds
		if spaceStatus != null and spaceStatus.currentStatus != GridSpaceInfo.GridSpaceStatus.CLOSED:
				return false
	#all squares are outside the grid map
	return true

func CheckIfOffGridPos(pos: Vector2) -> bool:
	var gridCoords : Vector2i = PositionToGridCoordinate(pos)
	var spaceStatus : GridSpaceInfo = GetGridSpace(gridCoords)
	#is out of max bounds
	if spaceStatus != null and spaceStatus.currentStatus != GridSpaceInfo.GridSpaceStatus.CLOSED:
			return false
	return true

func CheckIfOutsideSafeZone(piece : PieceLogic) -> bool:
	# offset by grid centering
	var pieceCoords : Vector2i = PositionToGridCoordinate(piece.GetOriginCellPosition() + global_position - gridCenterOffset)
	var cellOffsetsArray : Array[Vector2i] = piece.GetPieceShapeOffsetArray()
	for shapeCell in cellOffsetsArray:
		var spaceCoord : Vector2i = pieceCoords + shapeCell
		# if at least 1 square is in view
		if abs(spaceCoord.x) < SAFE_WIDTH and abs(spaceCoord.y) < SAFE_HEIGHT:
			return false
	return true

func PlacePiece(piece : PieceLogic) -> bool:
	var pieceCoords : Vector2i = PositionToGridCoordinate(piece.GetOriginCellPosition())
	return PlacePieceByCoordinates(piece, pieceCoords)

func PlacePieceByCoordinates(piece : PieceLogic, gridCoord : Vector2i) -> bool:
	if gridMode == GridMode.PLAY:
		if CheckLegalToPlace(piece) == false:
			return false
	SetGridSpacesByPieceShape(gridCoord, GridSpaceInfo.GridSpaceStatus.OCCUPIED, piece)
	piece.AssignMapGridCoordinates(gridCoord)
	
	if gridMode == GridMode.PLAY:
		grid_updated.emit()
	return true

func RemovePieceByCoordinates(gridCoord : Vector2i) -> PieceLogic:
	var gridInfo : GridSpaceInfo = GetGridSpace(gridCoord)
	if gridInfo == null:
		return null
	if gridInfo.currentStatus != GridSpaceInfo.GridSpaceStatus.OCCUPIED:
		return null
	var piece = gridInfo.occupyingPiece
	if gridMode == GridMode.PLAY:
		SetGridSpacesByPieceShape(PositionToGridCoordinate(piece.GetOriginCellPosition()), GridSpaceInfo.GridSpaceStatus.OPEN, piece)
	else:
		SetGridSpacesByPieceShape(PositionToGridCoordinate(piece.GetOriginCellPosition()), GridSpaceInfo.GridSpaceStatus.CLOSED, piece)
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
		for y in MAX_HEIGHT * 2:
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
