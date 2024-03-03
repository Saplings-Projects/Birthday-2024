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

func _ready():
	#TODO: disable or show preview based on progress saved
	match RandomNumberGenerator.new().randi_range(1,3):
		1:
			SetupButtonMode(LevelButtonMode.LOCKED)
		2:
			SetupButtonMode(LevelButtonMode.INCOMPLETE)
		3:
			SetupButtonMode(LevelButtonMode.COMPLETE)
	

func SetupButtonMode(buttonMode : LevelButtonMode):
	#tooltip_text = str(levelData.levelName, " by ", levelData.author)
	tooltip_text = levelData.levelName
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
		
