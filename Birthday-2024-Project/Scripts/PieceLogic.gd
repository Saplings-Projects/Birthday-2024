extends Sprite2D
class_name PieceLogic

enum PlacementStates { UNPLACED, HELD, PLACED }
enum RotationStates { DEG_0 = 0, DEG_90, DEG_180, DEG_270 }

const GAME_MANAGER_NODE_PATH = "/root/MainLevel/GameManager"
const ROTATION_ANIMATION_DURATION: float = 0.35 # Number of seconds a piece takes to rotate
const RETURN_ANIMATION_DURATION: float = 0.5 # Number of seconds a piece takes to return to it's return position when dropped
const PLACED_ANIMATION_DURATION: float = 0.2 # Number of seconds a piece take to move into it's placed position

@export_multiline var pieceShape : String
@export var isBlocker : bool
@export var fauna_player: AudioStreamPlayer2D
@export var sfx_player: AudioStreamPlayer2D
@export var fauna_samples: AudioSamples
@export var rotate_samples: AudioSamples
@export var place_samples: AudioSamples
@export var grab_samples: AudioSamples

var current_placement_state: PlacementStates
var levelGridReference : GridLogic
var cells: Array[Vector2i] # The spaces occupied by this piece when unrotated
var totalCells : int
var cellHeight : int
var cellWidth : int
# This is the grid space occupied by this piece's origin cell,
# all other occupied spaces can be found by adding _current_cells to this position
var placed_grid_position: Vector2i
var current_rotation_state: RotationStates

var _current_cells: Array[Vector2i] # The cell offsets occupied by this piece given rotation
var _movement_tween: Tween # Active tween for when this piece is moving to a position (e.g. when placed or returned). Set this to null when the tween is finished it's current rotation
var _current_angle_target: float # The rotation angle target for animation
var _rotation_tween: Tween # Active tween for when this piece is rotating. Set this to null when the tween is finished
var _originOffset : Vector2 #the offset from the transform center to the origin cell (0,0)
var _return_position: Vector2 # The position this piece returns to when not held or in the grid
var _last_grid_position : Vector2i = Vector2i(GridLogic.MAX_WIDTH + 1, GridLogic.MAX_HEIGHT + 1)
var _last_grid_rotation : RotationStates = RotationStates.DEG_0
var _cellStartingWidth : int
var _cellStartingHeight : int

func on_clicked():
	var game_manager: GameManager = get_node(GAME_MANAGER_NODE_PATH)
	if game_manager == null:
		return # This should never happen, but just in case
	game_manager.on_piece_clicked(self)

func on_piece_held():
	current_placement_state = PlacementStates.HELD
	cancel_movement_tween()


func play_grab_audio():
	_play_sfx_sample(grab_samples.get_random_sample())
	
	# Play Fauna sound
	var sample = fauna_samples.get_random_sample()
	
	if sample == null:
		return
	
	fauna_player.stop()
	fauna_player.stream = sample
	fauna_player.play()


func play_place_audio():
	_play_sfx_sample(place_samples.get_random_sample())


func play_rotate_audio():
	_play_sfx_sample(rotate_samples.get_random_sample())


func _play_sfx_sample(sample: AudioStream):
	if sample == null:
		return
	
	sfx_player.stop()
	sfx_player.stream = sample
	sfx_player.play()


func cancel_movement_tween():
	if _movement_tween != null:
		_movement_tween.stop()
	_movement_tween = null
	
func rotate_clockwise():
	# Update rotation variables
	if current_rotation_state == RotationStates.DEG_270:
		current_rotation_state = RotationStates.DEG_0
	else:
		current_rotation_state = current_rotation_state + 1 as RotationStates
	
	_current_angle_target += PI * 0.5
	update_current_cells()	
	_start_rotation_tween()
	
func rotate_anticlockwise():
	# Update rotation variables
	if current_rotation_state == RotationStates.DEG_0:
		current_rotation_state = RotationStates.DEG_270
	else:
		current_rotation_state = current_rotation_state - 1 as RotationStates
	
	_current_angle_target -= PI * 0.5
	update_current_cells()	
	_start_rotation_tween()
	
func cancel_rotation_tween():
	if _rotation_tween != null:
		_rotation_tween.stop()
	_rotation_tween = null

func update_current_cells():
	# Rotates the occupied cells of the piece, rotating around the bottom-left 0,0 cell
	match current_rotation_state:
		RotationStates.DEG_0: # No change from base cells
			for i in range(cells.size()):
				_current_cells[i] = cells[i]
		RotationStates.DEG_90: # Ascending x -> Ascending y | Ascending y -> Descending x
			for i in range(cells.size()):
				_current_cells[i] = Vector2i(-cells[i].y, cells[i].x)
		RotationStates.DEG_180: # Ascending x -> Descending x | Ascending y -> Descending y
			for i in range(cells.size()):
				_current_cells[i] = -cells[i]
		RotationStates.DEG_270: # Ascending x -> Descending y | Ascending y -> Ascending x
			for i in range(cells.size()):
				_current_cells[i] = Vector2i(cells[i].y, -cells[i].x)

#when not rotated, the origin cell is the top-most, left-most cell
func GetOriginCellOffset() -> Vector2:
	return _originOffset.rotated(rotation)
	
#when not rotated, the origin cell is the top-most, left-most cell
func GetOriginCellPosition() -> Vector2:
	return global_position + GetOriginCellOffset()

func GetPieceShapeOffsetArray() -> Array[Vector2i]:
	return _current_cells

func SetPieceRotation(pieceRotation : RotationStates, rotateInstantly : bool = true):
	current_rotation_state = pieceRotation
	match current_rotation_state:
		RotationStates.DEG_0:
			cellWidth = _cellStartingWidth
			cellHeight = _cellStartingHeight
			_current_angle_target = 0
		RotationStates.DEG_90:
			cellWidth = _cellStartingHeight
			cellHeight = _cellStartingWidth
			_current_angle_target = PI * 0.5
		RotationStates.DEG_180:
			cellWidth = _cellStartingWidth
			cellHeight = _cellStartingHeight
			_current_angle_target = PI
		RotationStates.DEG_270:
			cellWidth = _cellStartingHeight
			cellHeight = _cellStartingWidth
			_current_angle_target = PI * 1.5
			
	update_current_cells()
	if rotateInstantly:
		rotation = _current_angle_target
	else:
		_start_rotation_tween()

func AssignMapGridCoordinates(assignedCoords : Vector2i):
	current_placement_state = PlacementStates.PLACED
	placed_grid_position = assignedCoords
	#Record last successful placement
	if levelGridReference.gridMode == GridLogic.GridMode.EDIT:
		RecordGridPosition(assignedCoords)

func RecordGridPosition(gridCoords : Vector2i):
	_last_grid_position = gridCoords
	_last_grid_rotation = current_rotation_state
	_return_position = levelGridReference.GridCoordinateToPosition(gridCoords) - GetOriginCellOffset()
	
func return_piece(moveInstantly : bool = false):
	current_placement_state = PlacementStates.UNPLACED
	if levelGridReference.gridMode == GridLogic.GridMode.PLAY:
		if moveInstantly:
			global_position = _return_position
		else:
			movement_tween_to(_return_position, RETURN_ANIMATION_DURATION)
	else:
		#Pulled from the library but never successfully placed
		if _last_grid_position == Vector2i(GridLogic.MAX_WIDTH + 1, GridLogic.MAX_HEIGHT + 1):
			self.queue_free()
		else: #Go back to last successful placement
			if moveInstantly:
				global_position = _return_position
			else:
				movement_tween_to(_return_position, RETURN_ANIMATION_DURATION)
			SetPieceRotation(_last_grid_rotation, false)
			levelGridReference.PlacePieceByCoordinates(self, _last_grid_position)
	
func movement_tween_to(move_to: Vector2, duration: float):
	cancel_movement_tween()
	_movement_tween = get_tree().create_tween()
	_movement_tween.set_ease(Tween.EASE_OUT)
	_movement_tween.set_trans(Tween.TRANS_SINE)
	_movement_tween.tween_property(self, "global_position", move_to, duration)
	_movement_tween.tween_callback(func(): _movement_tween = null)
	
func place_piece(grid_position: Vector2i, move_to: Vector2):
	if levelGridReference.PlacePiece(self) == false:
		return_piece()
		return
	current_placement_state = PlacementStates.PLACED
	movement_tween_to(move_to, PLACED_ANIMATION_DURATION)
	
###############################################################################

func _initialize():
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
			if y > shape11.y:
				shape11.y = y
		elif cell == "\n":
			y += 1
			x = -1 #reset to 0
		x += 1
	
	var gridSpaceSize : Vector2 = Vector2(levelGridReference.tile_set.tile_size.x, levelGridReference.tile_set.tile_size.y)
	_cellStartingWidth = shape11.x - shape00.x + 1
	_cellStartingHeight = shape11.y - shape00.y + 1
	cellWidth = _cellStartingWidth
	cellHeight = _cellStartingHeight
	var midPoint : Vector2 = Vector2(cellWidth, cellHeight) * 0.5
	_originOffset = Vector2((originCell.x - midPoint.x + 0.5) * gridSpaceSize.x, (originCell.y - midPoint.y + 0.5) * gridSpaceSize.y)
	
	_current_cells = []
	for cell in cells:
		_current_cells.append(cell)

func _SetReturnPoint():
	_return_position = global_position

#func _process(delta):
	#print(global_position)

func _input(event):
	if event.is_action_pressed("GrabPiece"):
		# Check if the user has clicked on the piece's exact shape
		if _check_shape_clicked():
			print("Piece shape clicked: " + name)
			on_clicked()

func _check_shape_clicked() -> bool:
	var relative_click_position : Vector2 = get_global_mouse_position() - GetOriginCellPosition()
	for i in range(_current_cells.size()):
		var cell00 : Vector2 = Vector2((_current_cells[i].x - 0.5) * levelGridReference.tile_set.tile_size.x, (_current_cells[i].y - 0.5) * levelGridReference.tile_set.tile_size.y)
		var cell11 : Vector2 = cell00 + Vector2(levelGridReference.tile_set.tile_size.x, levelGridReference.tile_set.tile_size.y)
		if relative_click_position.x >= cell00.x and relative_click_position.x <= cell11.x and relative_click_position.y >= cell00.y and relative_click_position.y < cell11.y: # I really wish gdscript let you break statements across lines
			return true # Mouse is inside one of the piece's cells
	return false
	
func _start_rotation_tween():
	# Create the tween to animate the rotation
	cancel_rotation_tween()
	_rotation_tween = get_tree().create_tween()
	_rotation_tween.set_ease(Tween.EASE_OUT)
	_rotation_tween.set_trans(Tween.TRANS_SPRING)
	_rotation_tween.tween_property(self, "rotation", _current_angle_target, ROTATION_ANIMATION_DURATION)
	_rotation_tween.tween_callback(func(): _rotation_tween = null)
