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

func GoToLevel():
	var levelMenu : LevelsSelectMenu = get_node("../../..") as LevelsSelectMenu
	levelMenu.on_level_selected(levelData)

func SetupButtonMode(buttonMode : LevelButtonMode):
	#tooltip_text = str(levelData.levelName, " by ", levelData.author)
	tooltip_text = levelData.author
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
		
