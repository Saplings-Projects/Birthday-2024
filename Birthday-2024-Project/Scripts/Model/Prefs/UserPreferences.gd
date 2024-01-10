class_name UserPreferences
extends Preferences


var audio: AudioPreferences
var video: VideoPreferences


#region Preferences

func _apply_config(config: ConfigFile):
	audio = AudioPreferences.new(config)
	video = VideoPreferences.new(config)


func _apply_defaults():
	audio = AudioPreferences.new()
	video = VideoPreferences.new()


func _save_config(config: ConfigFile):
	audio._save_config(config)
	video._save_config(config)


#endregion Preferences
