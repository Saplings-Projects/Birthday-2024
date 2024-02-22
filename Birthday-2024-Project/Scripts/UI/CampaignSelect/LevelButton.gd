extends Button
class_name LevelButton

@export var levelData : LevelSetup

func GoToLevel():
	var levelMenu : LevelsSelectMenu = get_node("../../..") as LevelsSelectMenu
	levelMenu.on_level_selected(levelData)

func _ready():
	var levelPreview : TextureRect = get_child(0) as TextureRect
	levelPreview.texture = levelData.levelPreview
	
	#TODO: disable, enable, or show preview based on progress saved
	levelPreview.hide()
