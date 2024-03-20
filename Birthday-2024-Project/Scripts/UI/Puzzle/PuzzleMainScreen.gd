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

@export var photoTexture : TextureRect
@export var toHide : Array[Control]
@export var gridViewport : SubViewport
@export var shutterAnimation : AnimationPlayer

func play_win_animation():
	await get_tree().create_timer(0.05).timeout
	var screenCapture = gridViewport.get_texture().get_image()
	var tex = ImageTexture.create_from_image(screenCapture)
	photoTexture.texture = tex
	shutterAnimation.play("ShutterSnap")

func hide_win_animation():
	shutterAnimation.play("RESET")
	for controlNode in toHide:
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
