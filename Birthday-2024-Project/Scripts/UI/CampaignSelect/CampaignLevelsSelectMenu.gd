class_name CampaignLevelsSelectMenu
extends Control


signal back_to_campaign_select_menu
signal exit_game
signal open_settings_window
signal play


func on_back_clicked():
	back_to_campaign_select_menu.emit()


func on_exit_clicked():
	exit_game.emit()


func on_settings_clicked():
	open_settings_window.emit()


func on_play_clicked():
	play.emit()
