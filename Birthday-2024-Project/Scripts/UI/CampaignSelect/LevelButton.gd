extends Button
class_name LevelButton

enum LevelButtonMode {
	LOCKED,
	INCOMPLETE,
	COMPLETE
}

@export var levelData : LevelSetup
@export var levelPreviewRenderer : TextureRect
@export var monochromeShader : ShaderMaterial

var _levelIndex : int

func GoToLevel():
	var levelMenu : LevelsSelectMenu = get_node("../../..") as LevelsSelectMenu
	levelMenu.on_level_selected(levelData, _levelIndex)

func SetupButtonMode(buttonMode : LevelButtonMode, levelIndex : int):
	_levelIndex = levelIndex
	
	tooltip_text = str(levelData.levelName, "\nBy ", levelData.author)
	
	match buttonMode:
		LevelButtonMode.LOCKED:
			disabled = true
			levelPreviewRenderer.hide()
		LevelButtonMode.INCOMPLETE:
			disabled = false
			levelPreviewRenderer.texture = levelData.levelPreview
			levelPreviewRenderer.material = monochromeShader
			levelPreviewRenderer.show()
		LevelButtonMode.COMPLETE:
			disabled = false
			levelPreviewRenderer.texture = levelData.levelComplete
			levelPreviewRenderer.material = null
			levelPreviewRenderer.show()
		
