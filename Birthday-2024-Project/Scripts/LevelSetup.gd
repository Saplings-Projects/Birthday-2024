extends Resource
class_name LevelSetup

@export var jsonData : String
@export var message : String
@export var artFileName : String

func ParseJsonToData():
	var json = JSON.new()
	var error = json.parse(jsonData)
	if(error == OK):
		return json.data
	else:
		printerr("ERROR: Unable to parse json level data")
		return null
