class_name UserPreferences
extends Preferences


var audio: AudioPreferences


#region Preferences

func _apply_config(config: ConfigFile):
	audio = AudioPreferences.new(config)


func _apply_defaults():
	audio = AudioPreferences.new()


#endregion Preferences
