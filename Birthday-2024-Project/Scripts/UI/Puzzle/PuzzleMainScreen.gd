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

@export var win_text: Control
@export var win_particles : Array[GPUParticles2D]
@export var audio_player : AudioStreamPlayer
@export var photoTexture : TextureRect
@export var toEnable : Array[Control]

func play_win_animation():
	#win_text.show()
	
	#temporarily hide the skip button
	skip_button.visible = false
	
	await get_tree().create_timer(0.05)
	
	var screenCapture = get_viewport().get_texture().get_image()
	var tex = ImageTexture.create_from_image(screenCapture)
	photoTexture.texture = tex
	
	skip_button.visible = true
	
	audio_player.play()
	
	for controlNode in toEnable:
		controlNode.visible = true
	
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
