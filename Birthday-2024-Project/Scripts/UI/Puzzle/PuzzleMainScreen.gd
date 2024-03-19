class_name PuzzleMainScreen
extends Control


@export_group("UI Elements")
@export var exit_button: Button
@export var reset_button: Button
@export var back_button: Button
@export var skip_button: Button
@export var settings_button: Button
@export var edit_button: Button
@export var edit_anchor: Control
@export var library_button: Button
@export var library_anchor: Control
@export var import_button: Button
@export var import_anchor: Control
@export var export_button: Button
@export var export_anchor: Control

@export var win_particles : Array[GPUParticles2D]
@export var audio_player : AudioStreamPlayer
@export var photoTexture : TextureRect
@export var toEnable : Array[Control]
@export var gridViewport : SubViewport

func play_win_animation():
	var screenCapture = gridViewport.get_texture().get_image()
	var tex = ImageTexture.create_from_image(screenCapture)
	photoTexture.texture = tex
	
	audio_player.play()
	
	for controlNode in toEnable:
		controlNode.visible = true
	
	for particleEmitter in win_particles:
		particleEmitter.emitting = true

func hide_win_animation():
	for controlNode in toEnable:
		controlNode.visible = false

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
