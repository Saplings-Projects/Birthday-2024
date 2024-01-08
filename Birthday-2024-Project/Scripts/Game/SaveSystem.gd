class_name SaveSystem


var _config_path: String


func load_user_preferences() -> UserPreferences:
	var config = ConfigFile.new()
	var err = config.load(_config_path)
	
	match err:
		OK:
			return UserPreferences.new(config)
		ERR_FILE_NOT_FOUND:
			return UserPreferences.new()
		_:
			printerr("Encountered error while loading user preferences: ", err)
			return UserPreferences.new()


func save_user_preferences(prefs: UserPreferences):
	var config = ConfigFile.new()
	prefs._save_config(config)
	
	var err = config.save(_config_path)
	
	if err != OK:
		printerr("Encountered error while saving user preferences: ", err)


func _init(path: String):
	_config_path = path

