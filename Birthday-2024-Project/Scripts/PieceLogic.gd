extends Node2D
class_name PieceLogic

@export var followSpeed = 1

@export_multiline var pieceShape

var currentRotation = RotationEnum.Rotation;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	#if grabbed, follow mouse
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		position = get_viewport().get_mouse_position()
	
	#if released, check if on grid
		#if on grid, check if legal placement
			#if not legal placement, move to the side
			#if legal placement, claim spaces and check if level is completed
	pass
