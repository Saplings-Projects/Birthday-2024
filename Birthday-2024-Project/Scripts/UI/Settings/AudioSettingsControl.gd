class_name AudioSettingsControl
extends Control


@export_group("Audio Players")
@export var music_sample_player: AudioStreamPlayer2D # TODO: DELETE WHEN NO LONGER NEEDED
@export var sfx_sample_player: AudioStreamPlayer2D
@export var fauna_sample_player: AudioStreamPlayer2D

@export_group("Audio Samples")
@export var sfx_samples: AudioSamples
@export var fauna_samples: AudioSamples
@export var tone_sample: AudioStream # TODO: DELETE WHEN NO LONGER NEEDED


func on_fauna_slider_value_changed(value: float):
	_change_bus_volume(value, "Fauna")
	_play_sample(fauna_samples.get_random_sample(), fauna_sample_player)


func on_master_slider_value_changed(value: float):
	_change_bus_volume(value, "Master")


func on_music_slider_value_changed(value: float):
	_change_bus_volume(value, "Music")
	_play_sample(tone_sample, music_sample_player) # TODO: Remove when BGM is added.


func on_sfx_slider_value_changed(value: float):
	_change_bus_volume(value, "SFX")
	_play_sample(sfx_samples.get_random_sample(), sfx_sample_player)


func _change_bus_volume(value: float, bus_name: String):
	var db = log(clamp(value, 0.001, 1)) / log(10) * 20 # Convert to decibels
	var bus_idx = AudioServer.get_bus_index(bus_name)
	
	AudioServer.set_bus_volume_db(bus_idx, db)


func _play_sample(stream: AudioStream, player: AudioStreamPlayer2D):
	if stream == null or player.playing:
		return
	
	player.stream = stream
	player.play()


#region Node

func _ready():
	_change_bus_volume(1, "Master")
	_change_bus_volume(0.5, "Music")
	_change_bus_volume(0.5, "SFX")
	_change_bus_volume(0.5, "Fauna")


#endregion Node
