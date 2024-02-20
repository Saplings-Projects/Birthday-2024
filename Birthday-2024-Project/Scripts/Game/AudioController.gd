class_name AudioController
extends Node2D


var _prefs: AudioPreferences

const _MASTER_BUS: String = "Master"
const _MUSIC_BUS: String = "Music"
const _SFX_BUS: String = "SFX"


func set_master_volume(value: float):
	_prefs.master = value
	_set_bus_volume(value, _MASTER_BUS)


func set_music_volume(value: float):
	_prefs.music = value
	_set_bus_volume(value, _MUSIC_BUS)


func set_sfx_volume(value: float):
	_prefs.sfx = value
	_set_bus_volume(value, _SFX_BUS)


func _apply_prefs():
	set_master_volume(_prefs.master)
	set_music_volume(_prefs.music)
	set_sfx_volume(_prefs.sfx)


func _set_bus_volume(value: float, bus_name: String):
	var db = log(clamp(value, 0.001, 1)) / log(10) * 20 # Convert to decibels
	var bus_idx = AudioServer.get_bus_index(bus_name)
	
	AudioServer.set_bus_volume_db(bus_idx, db)

