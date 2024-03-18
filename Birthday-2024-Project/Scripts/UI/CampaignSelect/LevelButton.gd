extends Button
class_name LevelButton

enum LevelButtonMode {
	LOCKED,
	INCOMPLETE,
	COMPLETE
}

@export var levelPreviewRenderer : TextureRect
@export var monochromeShader : ShaderMaterial

var levelData : LevelSetup
var _levelIndex : int
var _levelSelectMenu : LevelsSelectMenu

func GoToLevel():
	var levelMenu : LevelsSelectMenu = get_node("../../..") as LevelsSelectMenu
	levelMenu.on_level_selected(levelData, _levelIndex)

func SetupButtonMode(buttonMode : LevelButtonMode, levelIndex : int):
	_levelIndex = levelIndex
	
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
			
func OnMouseEnter():
	_levelSelectMenu.SetLevelAndAuthor(levelData.levelName, levelData.author)

func OnMouseExit():
	_levelSelectMenu.SetLevelAndAuthor("", "")

func _ready():
	_levelSelectMenu = _findLevelSelectMenu()
	mouse_entered.connect(OnMouseEnter)
	mouse_exited.connect(OnMouseExit)

func _findLevelSelectMenu() -> LevelsSelectMenu:
	var parentNode = get_parent()
	while parentNode != null and parentNode is LevelsSelectMenu == false:
		parentNode = parentNode.get_parent()
	
	if parentNode != null:
		return parentNode as LevelsSelectMenu
	return null
