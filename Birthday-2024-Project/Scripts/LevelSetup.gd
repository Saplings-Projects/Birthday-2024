extends Resource
class_name LevelSetup

@export var levelData : Array[PieceSetup] = []
@export var jsonData : String
@export var author : String
@export var message : String
@export var levelName : String
@export var levelPreview : CompressedTexture2D
@export var levelComplete : CompressedTexture2D
@export var tutorialData : CampaignTutorialData

func RetrieveLevelData(popupController : ScreenLogic) -> Array[PieceSetup]:
	#if setup in editor
	if(levelData.size() > 0):
		return levelData
	else:
		var json = JSON.new()
		var error = json.parse(jsonData)
		if(error == OK):
			var parsedData : Array[PieceSetup]
			for pieceData in json.data:
				var parsedPiece : PieceSetup = PieceSetup.JsonParse(pieceData)
				if parsedPiece == null:
					printerr("ERROR: Unable to parse json level data")
					popupController.ShowTextPopup("ERROR", "Unable to read level text data. Re-export the level and try again")
					return []
				
				parsedData.push_back(parsedPiece)
			return parsedData
		else:
			printerr("ERROR: Unable to parse json level data")
			popupController.ShowTextPopup("ERROR", "Unable to read level text data. Re-export the level and try again")
			return []
