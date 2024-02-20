class_name LevelsSelectMenu
extends Control

@export var screenLogic : ScreenLogic


func _on_level_selected():
	#TODO: pass selected level
	screenLogic.screenManager.GoToScreen(load("res://MainScenes/main_level.tscn"), {})


func on_back_clicked():
	screenLogic.screenManager.GoToScreen(load("res://MainScenes/campaign_selection.tscn"), {})


func on_exit_clicked():
	screenLogic.ExitApplication()


func on_settings_clicked():
	screenLogic.screenManager.ShowSettings()
