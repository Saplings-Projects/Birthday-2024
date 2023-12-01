extends Node2D
class_name PieceLogic

enum PlacementStates { UNPLACED, HELD, PLACED }
enum RotationStates { DEG_0 = 0, DEG_90, DEG_180, DEG_270 }

const GAME_MANAGER_NODE_PATH = "/root/MainLevel/GameManager"
const GRID_MAP_NODE_PATH = "/root/MainLevel/GridMap"
const ROTATION_ANIMATION_DURATION: float = 0.35 # Number of seconds a piece takes to rotate
const RETURN_ANIMATION_DURATION: float = 0.5 # Number of seconds a piece takes to return to it's return position when dropped
const PLACED_ANIMATION_DURATION: float = 0.2 # Number of seconds a piece take to move into it's placed position

@export_multiline var pieceShape : String

var current_placement_state: PlacementStates
#var current_offset: Vector2 # For pieces with equal dimensions this is always the pivot_offset, for pieces with unequal dimensions the x and y component are swapped for 90 and 270 degree rotations
var levelGridReference : GridLogic
var cells: Array[Vector2i] # The spaces occupied by this piece when unrotated
var totalCells : int
var cellHeight : int
var cellWidth : int
# This is the grid space occupied by this piece's origin cell,
# all other occupied spaces can be found by adding _current_cells to this position
var placed_grid_position: Vector2i

var _current_cells: Array[Vector2i] # The cell offsets occupied by this piece given 
var _movement_tween: Tween # Active tween for when this piece is moving to a position (e.g. when placed or returned). Set this to null when the tween is finishedit's current rotation
var _current_rotation_state: RotationStates
var _current_angle_target: float # The rotation angle target for animation
var _rotation_tween: Tween # Active tween for when this piece is rotating. Set this to null when the tween is finished
var _originOffset : Vector2 #the offset from the transform center to the origin cell (0,0)
var _return_position: Vector2 # The position this piece returns to when not held or in the grid

func on_clicked():
	var game_manager: GameManager = get_node(GAME_MANAGER_NODE_PATH)
	if game_manager == null:
		return # This should never happen, but just in case
	game_manager.on_piece_clicked(self)

func on_piece_held():
	current_placement_state = PlacementStates.HELD
	cancel_movement_tween()
	
func cancel_movement_tween():
	if _movement_tween != null:
		_movement_tween.stop()
	_movement_tween = null
	
func rotate_clockwise():
	# Update rotation variables
	if _current_rotation_state == RotationStates.DEG_270:
		_current_rotation_state = RotationStates.DEG_0
	else:
		_current_rotation_state = _current_rotation_state + 1 as RotationStates
	_current_angle_target += PI * 0.5
	
	update_current_cells()
	#_rotate_offset() # Update the offset to keep the piece visually aligned with the grid
	_start_rotation_tween()
	
func rotate_anticlockwise():
	# Update rotation variables
	if _current_rotation_state == RotationStates.DEG_0:
		_current_rotation_state = RotationStates.DEG_270
	else:
		_current_rotation_state = _current_rotation_state - 1 as RotationStates
	_current_angle_target -= PI * 0.5
	
	update_current_cells()
	#_rotate_offset() # Update the offset to keep the piece visually aligned with the grid
	_start_rotation_tween()
	
func cancel_rotation_tween():
	if _rotation_tween != null:
		_rotation_tween.stop()
	_rotation_tween = null

func update_current_cells():
	# Rotates the occupied cells of the piece, rotating around the bottom-left 0,0 cell
	match _current_rotation_state:
		RotationStates.DEG_0: # No change from base cells
			for i in range(cells.size()):
				_current_cells[i] = cells[i]
		RotationStates.DEG_90: # Ascending x -> Ascending y | Ascending y -> Descending x
			for i in range(cells.size()):
				_current_cells[i] = Vector2i(cells[i].y, -cells[i].x)
		RotationStates.DEG_180: # Ascending x -> Descending x | Ascending y -> Descending y
			for i in range(cells.size()):
				_current_cells[i] = -cells[i]
		RotationStates.DEG_270: # Ascending x -> Descending y | Ascending y -> Ascending x
			for i in range(cells.size()):
				_current_cells[i] = Vector2i(-cells[i].y, cells[i].x)

#when not rotated, the origin cell is the bottom-left most cell
func GetOriginCellOffset() -> Vector2:
	return _originOffset.rotated(rotation)
	
#when not rotated, the origin cell is the bottom-left most cell
func GetOriginCellPosition() -> Vector2:
	return position + GetOriginCellOffset()

func GetPieceShapeOffsetArray() -> Array[Vector2i]:
	return _current_cells

func SetPieceRotation(pieceRotation : RotationStates):
	_current_rotation_state = pieceRotation
	match _current_rotation_state:
		RotationStates.DEG_0:
			_current_angle_target = 0
		RotationStates.DEG_90:
			_current_angle_target = PI * 0.5
		RotationStates.DEG_180:
			_current_angle_target = PI
		RotationStates.DEG_270:
			_current_angle_target = PI * 1.5
			
	update_current_cells()
	#_rotate_offset() # Update the offset to keep the piece visually aligned with the grid
	_start_rotation_tween()

func AssignMapGridCoordinates(assignedCoords : Vector2i):
	current_placement_state = PlacementStates.PLACED
	placed_grid_position = assignedCoords
	
func return_piece():
	current_placement_state = PlacementStates.UNPLACED
	movement_tween_to(_return_position, RETURN_ANIMATION_DURATION)
	
func movement_tween_to(move_to: Vector2, duration: float):
	cancel_movement_tween()
	_movement_tween = get_tree().create_tween()
	_movement_tween.set_ease(Tween.EASE_OUT)
	_movement_tween.set_trans(Tween.TRANS_SINE)
	_movement_tween.tween_property(self, "position", move_to, duration)
	_movement_tween.tween_callback(func(): _movement_tween = null)
	
func place_piece(grid_position: Vector2i, move_to: Vector2):
	if levelGridReference.PlacePiece(self) == false:
		return_piece()
		return
	current_placement_state = PlacementStates.PLACED
	movement_tween_to(move_to, PLACED_ANIMATION_DURATION)
	
###############################################################################

func _initialize():
	_return_position = position # In the future, this can be set when a level is loaded
	current_placement_state = PlacementStates.UNPLACED
	
	# Parse multiline string into vector2 cell array
	cells = []
	var x : int = 0
	var y : int = 0
	var originCell : Vector2i = Vector2i(-1,-1)
	totalCells = 0
	var shape00 : Vector2i = Vector2i(0,0)
	var shape11 : Vector2i = Vector2i(0,0)
	for cell in pieceShape:
		if cell == "1":
			#first cell becomes the origin cell that all others are in relation to
			if originCell == Vector2i(-1,-1):
				originCell = Vector2i(x,y)
			cells.append(Vector2i(x, y) - originCell)
			totalCells += 1
			if x > shape11.x:
				shape11.x = x
			if y < shape00.y:
				shape00.y = y
		elif cell == "\n":
			y -= 1 #y ends up negative since parsing reads top down
			x = -1 #reset to 0
		x += 1
	
	var gridSpaceSize : Vector2 = Vector2(levelGridReference.tile_set.tile_size.x, levelGridReference.tile_set.tile_size.y)
	cellWidth = shape11.x - shape00.x
	cellHeight = shape11.y - shape00.y
	var midPoint : Vector2 = Vector2(cellWidth, cellHeight) * 0.5
	var originPoint : Vector2 = originCell - shape00
	_originOffset = Vector2((originPoint.x - midPoint.x) * gridSpaceSize.x, (originPoint.y - midPoint.y) * gridSpaceSize.y)
	
	_current_cells = []
	for cell in cells:
		_current_cells.append(cell)
	
	#current_offset = pivot_offset # Get offset from pivot_offset

#func _process(delta):
	#print(position)

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			print("Piece texture clicked")
			# The texture rect of this piece has been clicked on, but not necessarily the piece's exact shape
			if _check_shape_clicked():
				print("Piece shape clicked")
				on_clicked()

func _check_shape_clicked() -> bool:
	var shape_origin = GetOriginCellPosition()
	#shape_origin += pivot_offset
	#shape_origin -= current_offset
	var mouse_position = get_viewport().get_mouse_position()
	var relative_click_position = mouse_position - shape_origin
	for i in range(_current_cells.size()):
		var cell00 = Vector2(_current_cells[i].x * levelGridReference.tile_set.tile_size.x, _current_cells[i].y * levelGridReference.tile_set.tile_size.y)
		var cell11 = cell00 + Vector2(levelGridReference.tile_set.tile_size.x, levelGridReference.tile_set.tile_size.y)
		if relative_click_position.x >= cell00.x and relative_click_position.x <= cell11.x and relative_click_position.y >= cell00.y and relative_click_position.y < cell11.y: # I really wish gdscript let you break statements across lines
			return true # Mouse is inside one of the piece's cells
	return false

#func _rotate_offset():
	#var new_offset_x = current_offset.y
	#var new_offset_y = current_offset.x
	#current_offset = Vector2(new_offset_x, new_offset_y)
	
func _start_rotation_tween():
	# Create the tween to animate the rotation
	cancel_rotation_tween()
	_rotation_tween = get_tree().create_tween()
	_rotation_tween.set_ease(Tween.EASE_OUT)
	_rotation_tween.set_trans(Tween.TRANS_SPRING)
	_rotation_tween.tween_property(self, "rotation", _current_angle_target, ROTATION_ANIMATION_DURATION)
	_rotation_tween.tween_callback(func(): _rotation_tween = null)
