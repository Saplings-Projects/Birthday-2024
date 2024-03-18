class_name LevelsSelectMenu
extends Control

const PASS_LEVEL_DATA_KEY = "PASS_LEVEL_DATA_KEY"
const PASS_LEVEL_INDEX_KEY = "PASS_LEVEL_INDEX_KEY"
const IS_CAMPAIGN_KEY = "IS_CAMPAIGN_KEY"
const BUTTONS_PER_PAGE_KEY = "BUTTONS_PER_PAGE_KEY"
const CAMPAIGN_LEVELS = "res://MainScenes/campaign_level_select_"
const SAPLING_LEVELS = "res://MainScenes/sapling_level_select_"

@export var screenLogic : ScreenLogic
@export var levelLibrary : LevelLibrary
@export var selectableButtons : Array[LevelButton]
@export var isCampaign : bool
@export var pageText : Label
@export var pageNumber : int
@export var lastPageNumber : int
@export var prevArrow : Button
@export var nextArrow : Button
@export var editorButton : Button
@export var levelNameText : Label
@export var authorNameText : Label

var _gm: GameMaster


func on_level_selected(levelData : LevelSetup, levelIndex : int):
	var transitionData = {}
	transitionData[PASS_LEVEL_DATA_KEY] = levelData
	transitionData[PASS_LEVEL_INDEX_KEY] = levelIndex
	transitionData[IS_CAMPAIGN_KEY] = isCampaign
	transitionData[BUTTONS_PER_PAGE_KEY] = selectableButtons.size()
	
	screenLogic.GoToScreen(load("res://MainScenes/main_level.tscn"), transitionData, ScreenManager.TransitionStyle.TURN_PAGE)

func on_prev_clicked():
	if(isCampaign):
		screenLogic.GoToScreen(load(str(CAMPAIGN_LEVELS, pageNumber - 1, ".tscn")), {}, ScreenManager.TransitionStyle.BACK_PAGE)
	else:
		screenLogic.GoToScreen(load(str(SAPLING_LEVELS, pageNumber - 1, ".tscn")), {}, ScreenManager.TransitionStyle.BACK_PAGE)

func on_next_clicked():
	if(isCampaign):
		screenLogic.GoToScreen(load(str(CAMPAIGN_LEVELS, pageNumber + 1, ".tscn")), {}, ScreenManager.TransitionStyle.TURN_PAGE)
	else:
		screenLogic.GoToScreen(load(str(SAPLING_LEVELS, pageNumber + 1, ".tscn")), {}, ScreenManager.TransitionStyle.TURN_PAGE)

func on_back_clicked():
	screenLogic.GoToScreen(load("res://MainScenes/campaign_selection.tscn"), {}, ScreenManager.TransitionStyle.BACK_PAGE)


func on_exit_clicked():
	screenLogic.ExitApplication()


func on_settings_clicked():
	screenLogic.screenManager.ShowSettings()
	
	
func on_editor_clicked():
	var transitionData = {}
	transitionData[PASS_LEVEL_DATA_KEY] = null
	transitionData[PASS_LEVEL_INDEX_KEY] = (pageNumber - 1) * selectableButtons.size()
	transitionData[IS_CAMPAIGN_KEY] = isCampaign
	transitionData[BUTTONS_PER_PAGE_KEY] = selectableButtons.size()
	
	screenLogic.GoToScreen(load("res://MainScenes/main_level.tscn"), transitionData, ScreenManager.TransitionStyle.TURN_PAGE)
	

func SetLevelAndAuthor(levelName : String, levelAuthor : String):
	levelNameText.text = levelName
	authorNameText.text = levelAuthor

func _ready():
	_gm = get_node(GameMaster.GLOBAL_GAME_MASTER_NODE)
	
	prevArrow.visible = pageNumber > 1
	nextArrow.visible = pageNumber < lastPageNumber
	pageText.visible = lastPageNumber > 1
	pageText.text = str(pageNumber, "/", lastPageNumber)
	editorButton.visible = !isCampaign
	
	var levelIndex : int = (pageNumber - 1) * selectableButtons.size()
	for button in selectableButtons:
		if levelLibrary.Levels.size() > levelIndex:
			var levelData = levelLibrary.Levels[levelIndex]
			button.levelData = levelData
			
			if isCampaign and levelIndex > _gm.progression_tracker.GetLastCampaignLevelCompleted() + 1:
				button.SetupButtonMode(LevelButton.LevelButtonMode.LOCKED, levelIndex)
			elif _gm.progression_tracker.IsLevelCompleted(levelData.resource_path):
				button.SetupButtonMode(LevelButton.LevelButtonMode.COMPLETE, levelIndex)
			else:
				button.SetupButtonMode(LevelButton.LevelButtonMode.INCOMPLETE, levelIndex)
		else:
			button.visible = false
		levelIndex += 1



