extends GridLogic
class_name EditorGridLogic

func ImportLevel(jsonImportData : String):
	var tempLevelSetup : LevelSetup = LevelSetup.new()
	tempLevelSetup.jsonData = jsonImportData
	LoadLevel(tempLevelSetup)

func LoadLevel(levelSetupData : LevelSetup):
	super.LoadLevel(levelSetupData)
	global_position = Vector2(0,0)

func ExportLevel() -> String:
	var pieceData : Array[PieceSetup]
	
	for pieceLogic in availablePieces:
		var pieceSetup = PieceSetup.new()
		pieceSetup.pieceID = pieceLogic.name
		pieceSetup.gridPosition = pieceLogic.placed_grid_position
		pieceSetup.pieceRotation = pieceLogic.current_rotation_state
		pieceData.push_back(pieceSetup)
	
	for pieceLogic in blockerPieces:
		var pieceSetup = PieceSetup.new()
		pieceSetup.pieceID = pieceLogic.name
		pieceSetup.gridPosition = pieceLogic.placed_grid_position
		pieceSetup.pieceRotation = pieceLogic.current_rotation_state
		pieceData.push_back(pieceSetup)
		
	return JSON.stringify(pieceData)

#only other pieces will block a piece being placed
func CheckLegalToPlace(piece : PieceLogic) -> bool:
	var pieceCoords : Vector2i = PositionToGridCoordinate(piece.GetOriginCellPosition())
	var cellOffsetsArray : Array[Vector2i] = piece.GetPieceShapeOffsetArray()
	for shapeCell in cellOffsetsArray:
		var spaceStatus : GridSpaceInfo = GetGridSpace(pieceCoords + shapeCell)
		if spaceStatus.currentStatus == GridSpaceInfo.GridSpaceStatus.OCCUPIED:
			return false
	return true
	
func PlacePiece(piece : PieceLogic) -> bool:
	var pieceCoords : Vector2i = PositionToGridCoordinate(piece.GetOriginCellPosition())
	SetGridSpacesByPieceShape(pieceCoords, GridSpaceInfo.GridSpaceStatus.OCCUPIED, piece)
	piece.AssignMapGridCoordinates(pieceCoords)
	return true

#delete those map spaces instead
func RemovePieceByCoordinates(gridCoord : Vector2i) -> PieceLogic:
	var gridInfo : GridSpaceInfo = GetGridSpace(gridCoord)
	if gridInfo.currentStatus != GridSpaceInfo.GridSpaceStatus.OCCUPIED:
		return null
	var piece = gridInfo.occupyingPiece
	SetGridSpacesByPieceShape(PositionToGridCoordinate(piece.GetOriginCellPosition()), GridSpaceInfo.GridSpaceStatus.CLOSED, piece)
	piece.return_piece()
	return piece
