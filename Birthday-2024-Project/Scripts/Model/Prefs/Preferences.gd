class_name Preferences


func _apply_config(config: ConfigFile):
	pass


func _apply_defaults():
	pass


func _init(config: ConfigFile = null):
	if config == null:
		_apply_defaults()
	else:
		_apply_config(config)

