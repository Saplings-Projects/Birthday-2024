class_name GameManager
extends Node2D

@export var grid: GridLogic

@export var held_piece_flat_speed: float
@export var held_piece_distance_speed: float
@export var held_piece_settle_delay: float # The amount of time the held piece must remain motionless before settling
@export var held_piece_settle_animation_duration: float # The amount of time the held piece takes to move to it's settled position

@export_group("States")
@export var empty_state: GameEmptyState
@export var play_state: GamePlayState
@export var win_state: GameWinState

@export_group("")
#TODO: have this passed by the level selector in the future
@export var debug_setupData : LevelSetup

var held_piece: PieceLogic
var held_piece_settled: bool
var previous_mouse_position: Vector2
var remaining_settle_delay: float

var _can_interact: bool # TODO: DELETE THIS WHEN NO LONGER NEEDED.
var _current_state: GameState
var _is_inititialized: bool
var _previous_state: GameState

signal initialized_event()
signal state_changed_event(state)


func get_current_state() -> GameState:
	return _current_state


func switch_to_play_state():
	_switch_state(play_state)


func switch_to_win_state():
	_switch_state(win_state)


func _switch_state(state: GameState):
	_previous_state = _current_state
	_current_state = state
	
	if _previous_state != null:
		_previous_state.exit_state()
	
	_current_state.enter_state()
	
	state_changed_event.emit(state)


func on_piece_clicked(clicked_piece: PieceLogic):
	if not _can_interact or held_piece != null:
		return
	if clicked_piece.isBlocker:
		return
	
	held_piece = clicked_piece
	
	clicked_piece.play_grab_audio()
	_remove_occupied_cells(held_piece)
	_reset_settled()


func _ready():
	# State
	_current_state = empty_state
	empty_state.set_manager(self)
	play_state.set_manager(self)
	win_state.set_manager(self)
	
	#TODO: Load level using Level Select
	grid.LoadLevel(debug_setupData)

func _process(delta):
	if not _is_inititialized:
		_is_inititialized = true
		
		initialized_event.emit()
		switch_to_play_state()
	
	if not _can_interact or held_piece == null:
		return
		
	_do_held_piece_settle(delta)
	_held_piece_towards_cursor(delta)
	_rotate_held_piece()
	_do_place_held_piece()

func _remove_occupied_cells(piece: PieceLogic):
	if piece.current_placement_state != PieceLogic.PlacementStates.PLACED:
		return
	grid.RemovePieceByCoordinates(piece.placed_grid_position)

func _held_piece_towards_cursor(delta):
	if held_piece_settled:
		return
	
	var target_position: Vector2 = get_global_mouse_position()
	#target_position -= held_piece.pivot_offset
	var held_piece_to_mouse: Vector2 = target_position - held_piece.global_position
	var held_piece_to_mouse_distance: float = held_piece_to_mouse.length()
	
	var distance_step: float = (held_piece_flat_speed + held_piece_distance_speed * held_piece_to_mouse_distance) * delta
	if distance_step > held_piece_to_mouse_distance:
		held_piece.global_position = target_position
		return
	held_piece.global_position += held_piece_to_mouse.normalized() * distance_step

func _rotate_held_piece():
	if Input.is_action_just_pressed("RotateClockwise"):
		held_piece.rotate_clockwise()
		held_piece.play_rotate_audio()
		_reset_settled()
	elif Input.is_action_just_pressed("RotateAnticlockwise"):
		held_piece.rotate_anticlockwise()
		held_piece.play_rotate_audio()
		_reset_settled()


func _get_held_piece_grid_origin() -> Vector2i:
	return grid.PositionToGridCoordinate(held_piece.GetOriginCellPosition())

func _do_held_piece_settle(delta):
	var mouse_position : Vector2 = get_global_mouse_position()
	var mouse_distance_moved : float = (mouse_position - previous_mouse_position).length()
	if mouse_distance_moved > 0.1:
		_reset_settled()
		held_piece.cancel_movement_tween()
		previous_mouse_position = mouse_position
	else:
		if held_piece_settled:
			return
		remaining_settle_delay -= delta
		if remaining_settle_delay <= 0:
			held_piece_settled = true
			var held_piece_grid_origin : Vector2i = _get_held_piece_grid_origin()
			if grid.CheckLegalToPlace(held_piece) == false:
				return
			var settle_position : Vector2 = _held_piece_placed_position(held_piece_grid_origin)
			held_piece.movement_tween_to(settle_position, held_piece_settle_animation_duration)

func _reset_settled():
	held_piece_settled = false
	remaining_settle_delay = held_piece_settle_delay

func _held_piece_placed_position(held_piece_grid_origin: Vector2i) -> Vector2:
	var placed_position : Vector2 = grid.GridCoordinateToPosition(held_piece_grid_origin)
	placed_position -= held_piece.GetOriginCellOffset()
	return placed_position

func _do_place_held_piece():
	# Try to place the held piece
	if !Input.is_action_just_released("PlacePiece"):
		return # Place piece input was not given
	if held_piece == null:
		return # There is no held piece to place
	
	# check if the grid can accommodate the held piece
	if grid.CheckLegalToPlace(held_piece) == false:
		held_piece.return_piece()
		held_piece = null
		return # Piece does not fit
	
	# Find the grid aligned position on screen to move the placed piece to
	var held_piece_grid_origin : Vector2i = _get_held_piece_grid_origin()
	var placed_position : Vector2 = _held_piece_placed_position(held_piece_grid_origin)
	held_piece.place_piece(held_piece_grid_origin, placed_position)
	held_piece.play_place_audio()
	held_piece = null # Piece is no longer being held
