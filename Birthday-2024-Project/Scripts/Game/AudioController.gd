class_name AudioController
extends Node2D


var _prefs: AudioPreferences

const _fauna_bus: String = "Fauna"
const _master_bus: String = "Master"
const _music_bus: String = "Music"
const _sfx_bus: String = "SFX"


func apply_prefs(prefs: UserPreferences):
	var audio = prefs.audio;
	
	set_master_volume(audio.master)
	set_music_volume(audio.music)
	set_sfx_volume(audio.sfx)
	set_fauna_volume(audio.fauna)


func set_fauna_volume(value: float):
	_prefs.fauna = value
	_set_bus_volume(value, _fauna_bus)


func set_master_volume(value: float):
	_prefs.master = value
	_set_bus_volume(value, _master_bus)


func set_music_volume(value: float):
	_prefs.music = value
	_set_bus_volume(value, _music_bus)


func set_sfx_volume(value: float):
	_prefs.sfx = value
	_set_bus_volume(value, _sfx_bus)


func _set_bus_volume(value: float, bus_name: String):
	var db = log(clamp(value, 0.001, 1)) / log(10) * 20 # Convert to decibels
	var bus_idx = AudioServer.get_bus_index(bus_name)
	
	AudioServer.set_bus_volume_db(bus_idx, db)

