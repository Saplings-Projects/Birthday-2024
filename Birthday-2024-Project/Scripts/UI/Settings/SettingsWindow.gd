class_name SettingsWindow
extends CanvasLayer


var _gm: GameMaster

signal close_settings_window


func on_close_clicked():
	_gm.save_preferences()
	close_settings_window.emit()


#region Node

func _ready():
	_gm = get_node("/root/GlobalGameMaster")


#endregion Node
