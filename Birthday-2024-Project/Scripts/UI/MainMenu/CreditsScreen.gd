class_name CreditsScreen
extends Control

@export var myScreen : ScreenLogic

signal back_to_main_menu
signal exit_game
signal open_settings_window

func _on_exit_button_button_up():
	myScreen.ExitApplication()

func _on_back_button_button_up():
	myScreen.GoToScreen(load("res://MainScenes/main_menu.tscn"), {}, ScreenManager.TransitionStyle.BACK_PAGE)

func _on_settings_button_button_up():
	myScreen.ShowSettings()
