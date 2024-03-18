class_name CampaignSelectUiManager
extends Control

@export var screenLogic : ScreenLogic
@export var start_screen: CampaignSelectStartScreen

func _on_exit_clicked():
	screenLogic.ExitApplication()

func _on_settings_clicked():
	screenLogic.screenManager.ShowSettings()

func _on_campaign_clicked():
	screenLogic.GoToScreen(load("res://MainScenes/campaign_level_select_1.tscn"), {}, ScreenManager.TransitionStyle.TURN_PAGE)

func _on_saplings_clicked():
	screenLogic.GoToScreen(load("res://MainScenes/sapling_level_select_1.tscn"), {}, ScreenManager.TransitionStyle.TURN_PAGE)

func _on_back_clicked():
	screenLogic.GoToScreen(load("res://MainScenes/main_menu.tscn"), {}, ScreenManager.TransitionStyle.BACK_PAGE)
	
#region Node

func _ready():
	start_screen.exit_button.pressed.connect(_on_exit_clicked)
	start_screen.settings_button.pressed.connect(_on_settings_clicked)
	start_screen.campaign_button.pressed.connect(_on_campaign_clicked)
	start_screen.saplings_button.pressed.connect(_on_saplings_clicked)
	start_screen.back_button.pressed.connect(_on_back_clicked)

#endregion None
