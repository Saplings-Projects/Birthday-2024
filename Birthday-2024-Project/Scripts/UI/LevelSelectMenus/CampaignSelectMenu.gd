class_name CampaignSelectMenu
extends Control


signal back_to_main_menu
signal exit_game
signal open_settings_window
signal open_campaign_levels
signal open_saplings_levels


func on_back_clicked():
	back_to_main_menu.emit()


func on_exit_clicked():
	exit_game.emit()
	
	
func on_settings_clicked():
	open_settings_window.emit()


func _on_campaign_levels_clicked():
	open_campaign_levels.emit()


func _on_saplings_levels_clicked():
	open_saplings_levels.emit()
