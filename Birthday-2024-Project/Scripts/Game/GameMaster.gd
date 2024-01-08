class_name GameMaster
extends Node2D


@export var audio_controller: AudioController

# State/Prefs
var user_prefs: UserPreferences

# Controllers
var _save_system: SaveSystem


func _apply_settings():
	audio_controller.apply_prefs(user_prefs)


func _load_data():
	user_prefs = _save_system.load_user_preferences()
	
	audio_controller._prefs = user_prefs.audio


#region Node

func _ready():
	_save_system = SaveSystem.new("user://UserPref.pref")
	
	_load_data()
	_apply_settings()


#endregion Node
