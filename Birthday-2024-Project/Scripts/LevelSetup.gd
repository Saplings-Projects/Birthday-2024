extends Resource
class_name LevelSetup

@export var levelData : Array[PieceSetup] = []
@export var jsonData : String
@export var message : String
@export var artFileName : String

func RetrieveLevelData() -> Array[PieceSetup]:
	#if setup in editor
	if(levelData.size() > 0):
		return levelData
	else:
		var json = JSON.new()
		var error = json.parse(jsonData)
		if(error == OK):
			return json.data
		else:
			printerr("ERROR: Unable to parse json level data")
			return []
