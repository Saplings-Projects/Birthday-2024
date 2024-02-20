class_name CampaignSelectUiManager
extends Control

@export var screenLogic : ScreenLogic
@export var start_screen: CampaignSelectStartScreen

func _on_exit_clicked():
	screenLogic.ExitApplication()

func _on_settings_clicked():
	screenLogic.screenManager.ShowSettings()

func _on_campaign_clicked():
	screenLogic.screenManager.GoToScreen(load("res://MainScenes/campaign_level_select.tscn"), {})

func _on_saplings_clicked():
	screenLogic.screenManager.GoToScreen(load("res://MainScenes/sapling_level_select.tscn"), {})

func _on_back_clicked():
	screenLogic.GoToScreen(load("res://MainScenes/main_menu.tscn"), {})
	
#region Node

func _ready():
	start_screen.exit_button.button_up.connect(_on_exit_clicked)
	start_screen.settings_button.button_up.connect(_on_settings_clicked)
	start_screen.campaign_button.button_up.connect(_on_campaign_clicked)
	start_screen.saplings_button.button_up.connect(_on_saplings_clicked)
	start_screen.back_button.button_up.connect(_on_back_clicked)

#endregion None
