class_name PuzzleMainScreen
extends Control


@export_group("UI Elements")
@export var exit_button: Button
@export var reset_button: Button
@export var back_button: Button
@export var skip_button: Button
@export var settings_button: Button
@export var edit_button: Button
@export var library_button: Button
@export var import_button: Button
@export var export_button: Button

@export var win_text: Control
@export var win_particles : Array[GPUParticles2D]
@export var audio_player : AudioStreamPlayer

func play_win_animation():
	#win_text.show()
	audio_player.play()
	for particleEmitter in win_particles:
		particleEmitter.emitting = true

func is_a_button_hovered() -> bool:
	var buttons = [
		exit_button, 
		reset_button, 
		back_button, 
		skip_button, 
		settings_button, 
		edit_button, 
		library_button, 
		import_button, 
		export_button]
	
	var hitboxes = []
	
	for b : Button in buttons:
		if b.visible and b.is_hovered():
			return true
	
	return false
