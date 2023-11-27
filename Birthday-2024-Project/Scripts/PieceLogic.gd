extends Node2D
class_name PieceLogic

@export_multiline var pieceShape

var currentRotation = RotationEnum.Rotation.NONE;
var gridHeight : int
var gridWidth : int
var totalSquares : int
var levelGridReference : GridLogic
var gridCoords : Vector2i
var isOnGrid = false

#when not rotated, the origin square is the top-left most square
func GetOriginSquarePosition():
	return position

func SetPieceRotation(pieceRotation : RotationEnum.Rotation):
	currentRotation = pieceRotation
	#TODO: make the rotation be an animation or some other effect
	match currentRotation:
		RotationEnum.Rotation.NONE:
			rotation = 0
			pass
		RotationEnum.Rotation.CLOCKWISE90:
			rotation = 90
			pass
		RotationEnum.Rotation.FLIPPED180:
			rotation = 180
			pass
		RotationEnum.Rotation.COUNTERWISE90:
			rotation = -90

func GetPieceShapeOffsetArray():
	var squareOffsetsArray = []
	squareOffsetsArray.push_back(Vector2i(0, 0))
	
	#for each character in Piece Shape string, describe each square

	#modify the offset coordinates based on the rotation of the piece
	match currentRotation:
		RotationEnum.Rotation.NONE:
			#do nothing
			pass
		RotationEnum.Rotation.CLOCKWISE90:
			pass
		RotationEnum.Rotation.FLIPPED180:
			pass
		RotationEnum.Rotation.COUNTERWISE90:
			pass
	
	#TODO: properly record max gridHeight, gridWidth, total number of squares
	gridHeight = 1
	gridWidth = 1
	totalSquares = 1
	return squareOffsetsArray

func AssignMapGridCoordinates(assignedCoords : Vector2i):
	isOnGrid = true
	gridCoords = assignedCoords

func ClearMapGridCoordinates():
	isOnGrid = false

###############################################################################

# # Called when the node enters the scene tree for the first time.
# func _ready():
# 	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	#if grabbed, follow mouse
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		#check if pulling a piece off the grid map
		if isOnGrid:
			levelGridReference.RemovePieceByCoordinates(GetOriginSquarePosition())
		#DEBUG, not even good debug...
		position = get_viewport().get_mouse_position()
	
	# #if released
	# 	if levelGridReference.CheckIfLegalToPlace(self):
	# 		#if legal placement, claim spaces and check if level is completed
	#		levelGridReference.PlacePiece(self)
	#		#snap to grid
	# 		pass
	# 	else:
	# 		#if not legal placement, move to the side
	# 		pass
