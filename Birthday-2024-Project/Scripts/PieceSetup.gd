extends Resource
class_name PieceSetup

const ID_KEY = "PIECE_SETUP_ID_KEY"
const GRID_X_KEY = "PIECE_SETUP_GRID_POSITION_X_KEY"
const GRID_Y_KEY = "PIECE_SETUP_GRID_POSITION_Y_KEY"
const ROTATION_KEY = "PIECE_SETUP_ROTATION_KEY"

@export var pieceID : String
@export var gridPosition : Vector2i
@export var pieceRotation : PieceLogic.RotationStates
	
static func JsonParse(jsonData : String) -> PieceSetup:
	var parsedData : PieceSetup = PieceSetup.new()
	var json = JSON.new()
	var error = json.parse(jsonData)
	if(error == OK):
		var parsedDictionary : Dictionary = json.data 
		parsedData.pieceID = parsedDictionary[ID_KEY]
		parsedData.gridPosition = Vector2(parsedDictionary[GRID_X_KEY], parsedDictionary[GRID_Y_KEY])
		parsedData.pieceRotation = parsedDictionary[ROTATION_KEY]
	else:
		printerr("ERROR: Unable to parse json setup data")
	return parsedData

func JsonSerialize() -> String:
	var dictionaryToSerialize : Dictionary = {}
	dictionaryToSerialize[ID_KEY] = pieceID
	dictionaryToSerialize[GRID_X_KEY] = gridPosition.x
	dictionaryToSerialize[GRID_Y_KEY] = gridPosition.y
	dictionaryToSerialize[ROTATION_KEY] = pieceRotation
	return JSON.stringify(dictionaryToSerialize)
