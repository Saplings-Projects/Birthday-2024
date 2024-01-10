class_name GameMaster
extends Node2D


# Controllers
@export var audio_controller: AudioController
@export var video_controller: VideoController

# State/Prefs
var user_prefs: UserPreferences

var _save_system: SaveSystem


func save_preferences():
	_save_system.save_user_preferences(user_prefs)


func _apply_settings():
	audio_controller._apply_prefs()
	video_controller._apply_prefs()


func _load_data():
	user_prefs = _save_system.load_user_preferences()
	
	audio_controller._prefs = user_prefs.audio
	video_controller._prefs = user_prefs.video


#region Node

func _ready():
	_save_system = SaveSystem.new("user://UserPref.pref")
	
	_load_data()
	_apply_settings()


#endregion Node
