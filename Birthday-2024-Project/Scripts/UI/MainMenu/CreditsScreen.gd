class_name CreditsScreen
extends Control


signal back_to_main_menu
signal exit_game
signal open_settings_window

func _on_settings_button_button_up():
	open_settings_window.emit()

func _on_back_button_button_up():
	back_to_main_menu.emit()

func _on_exit_button_button_up():
	exit_game.emit()
