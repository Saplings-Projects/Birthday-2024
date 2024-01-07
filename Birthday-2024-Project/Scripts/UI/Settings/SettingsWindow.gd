class_name SettingsWindow
extends Control


signal close_settings_window


func on_close_clicked():
	close_settings_window.emit()

