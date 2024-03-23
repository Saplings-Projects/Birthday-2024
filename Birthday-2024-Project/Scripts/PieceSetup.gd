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
		
		if parsedDictionary.has(ID_KEY) == false:
			printerr("ERROR: Unable to parse piece ID data")
			return null
		
		parsedData.pieceID = parsedDictionary[ID_KEY]
		if ResourceLoader.exists("res://ScenePrefabs/Pieces/" + parsedData.pieceID + ".tscn") == false:
			printerr("ERROR: Invalid piece ID")
			return null

		if parsedDictionary.has(GRID_X_KEY) == false or parsedDictionary.has(GRID_Y_KEY) == false:
			printerr("ERROR: Unable to parse piece grid data")
			return null

		parsedData.gridPosition = Vector2(parsedDictionary[GRID_X_KEY], parsedDictionary[GRID_Y_KEY])
		
		if parsedDictionary.has(ROTATION_KEY) == false:
			printerr("ERROR: Unable to parse piece rotation data")
			return null
		parsedData.pieceRotation = parsedDictionary[ROTATION_KEY]
	else:
		printerr("ERROR: Unable to parse piece setup data")
		return null
	return parsedData

func JsonSerialize() -> String:
	var dictionaryToSerialize : Dictionary = {}
	dictionaryToSerialize[ID_KEY] = pieceID
	dictionaryToSerialize[GRID_X_KEY] = gridPosition.x
	dictionaryToSerialize[GRID_Y_KEY] = gridPosition.y
	dictionaryToSerialize[ROTATION_KEY] = pieceRotation
	return JSON.stringify(dictionaryToSerialize)
