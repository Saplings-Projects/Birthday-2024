class_name LevelsSelectMenu
extends Control

const PASS_LEVEL_DATA_KEY = "PASS_LEVEL_DATA_KEY"
const CAMPAIGN_LEVELS = "res://MainScenes/campaign_level_select_"
const SAPLING_LEVELS = "res://MainScenes/sapling_level_select_"

@export var screenLogic : ScreenLogic
@export var isCampaign : bool
@export var pageText : Label
@export var pageNumber : int
@export var lastPageNumber : int
@export var prevArrow : Button
@export var nextArrow : Button

func on_level_selected(levelData : LevelSetup):
	screenLogic.screenManager.GoToScreen(load("res://MainScenes/main_level.tscn"), { PASS_LEVEL_DATA_KEY : levelData }, true)

func on_prev_clicked():
	if(isCampaign):
		screenLogic.screenManager.GoToScreen(load(str(CAMPAIGN_LEVELS, pageNumber - 1, ".tscn")), {}, true)
	else:
		screenLogic.screenManager.GoToScreen(load(str(SAPLING_LEVELS, pageNumber - 1, ".tscn")), {}, true)

func on_next_clicked():
	if(isCampaign):
		screenLogic.screenManager.GoToScreen(load(str(CAMPAIGN_LEVELS, pageNumber + 1, ".tscn")), {}, true)
	else:
		screenLogic.screenManager.GoToScreen(load(str(SAPLING_LEVELS, pageNumber + 1, ".tscn")), {}, true)

func on_back_clicked():
	screenLogic.screenManager.GoToScreen(load("res://MainScenes/campaign_selection.tscn"), {}, true)


func on_exit_clicked():
	screenLogic.ExitApplication()


func on_settings_clicked():
	screenLogic.screenManager.ShowSettings()

func _ready():
	prevArrow.disabled = pageNumber == 1
	nextArrow.disabled = pageNumber == lastPageNumber
	pageText.visible = lastPageNumber > 1
	pageText.text = str(pageNumber, "/", lastPageNumber)
