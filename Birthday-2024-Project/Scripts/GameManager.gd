class_name GameManager
extends Node2D

@export var grid: GridLogic
@export var deletionZone : Control
@export var myScreen : ScreenLogic

@export var held_piece_flat_speed: float
@export var held_piece_distance_speed: float
@export var place_piece_delay: float # The amount of time user input is blocked while the piece is being placed

@export var levelNameText : Label
@export var authorText : Label

@export var puzzle_main_screen : PuzzleMainScreen

@export_group("States")
@export var empty_state: GameEmptyState
@export var play_state: GamePlayState
@export var win_state: GameWinState
@export var edit_state: GameEditState
@export var test_state: GameTestState

var held_piece: PieceLogic
var held_piece_cell: int
var previous_mouse_position: Vector2
var previous_mouse_grid_pos: Vector2i
var overPieceLibrary : bool
var placing_piece: bool #Track when _do_place_held_piece is running and prevent rotation
var remaining_placing_delay : float
var placing_locked_position : Vector2

var _can_interact: bool
var _current_state: GameState
var _is_inititialized: bool
var _previous_state: GameState
var _gm : GameMaster
var _levelData : LevelSetup

signal initialized_event()
signal state_changed_event(state)

func retrieve_mouse_position() -> Vector2:
	if !placing_piece:
		return get_global_mouse_position()
	return placing_locked_position
	
func is_mouse_over_button() -> bool:
	return puzzle_main_screen.is_a_button_hovered()
	
func go_to_level_select():
	var thisLevelIndex : int = myScreen.transitionData[LevelsSelectMenu.PASS_LEVEL_INDEX_KEY]
	var buttonsPerPage : int = myScreen.transitionData[LevelsSelectMenu.BUTTONS_PER_PAGE_KEY]
	var pageNum : int = 1 + floori(thisLevelIndex / buttonsPerPage)
	
	if myScreen.transitionData[LevelsSelectMenu.IS_CAMPAIGN_KEY]:
		myScreen.GoToScreen(load(str(LevelsSelectMenu.CAMPAIGN_LEVELS, pageNum, ".tscn")), {}, ScreenManager.TransitionStyle.BACK_PAGE)
	else:
		myScreen.GoToScreen(load(str(LevelsSelectMenu.SAPLING_LEVELS, pageNum, ".tscn")), {}, ScreenManager.TransitionStyle.BACK_PAGE)

func go_to_next_level():
	var thisLevelIndex : int = myScreen.transitionData[LevelsSelectMenu.PASS_LEVEL_INDEX_KEY]
	var transitionData : Dictionary = {}
	transitionData[LevelsSelectMenu.PASS_LEVEL_INDEX_KEY] = thisLevelIndex + 1
	var buttonsPerPage : int = myScreen.transitionData[LevelsSelectMenu.BUTTONS_PER_PAGE_KEY]
	transitionData[LevelsSelectMenu.BUTTONS_PER_PAGE_KEY] = buttonsPerPage
	
	if myScreen.transitionData[LevelsSelectMenu.IS_CAMPAIGN_KEY]:
		#last level
		if thisLevelIndex + 1 >= _gm.campaign_level_library.Levels.size():
			go_to_level_select()
		#go to next level if present, it will go to it no matter if it's unlocked but won't mark it as complete
		else:
			transitionData[LevelsSelectMenu.IS_CAMPAIGN_KEY] = true
			transitionData[LevelsSelectMenu.PASS_LEVEL_DATA_KEY] = _gm.campaign_level_library.Levels[thisLevelIndex + 1]
			_gm.progression_tracker.SetLatestCampaignLevelCompleted(thisLevelIndex)
			myScreen.GoToScreen(load("res://MainScenes/main_level.tscn"), transitionData, ScreenManager.TransitionStyle.TURN_PAGE)
	else:
		#last level
		if thisLevelIndex + 1 >= _gm.submitted_level_library.Levels.size():
			go_to_level_select()
		else:
			transitionData[LevelsSelectMenu.IS_CAMPAIGN_KEY] = false
			transitionData[LevelsSelectMenu.PASS_LEVEL_DATA_KEY] = _gm.submitted_level_library.Levels[thisLevelIndex + 1]
			myScreen.GoToScreen(load("res://MainScenes/main_level.tscn"), transitionData, ScreenManager.TransitionStyle.TURN_PAGE)
		
	

func get_current_state() -> GameState:
	return _current_state


func switch_to_play_state():
	_switch_state(play_state)


func switch_to_win_state():
	_switch_state(win_state)


func switch_to_edit_state():
	_switch_state(edit_state)


func switch_to_test_state():
	_switch_state(test_state)


func _switch_state(state: GameState):
	_previous_state = _current_state
	_current_state = state
	
	if _previous_state != null:
		_previous_state.exit_state()
	
	_current_state.enter_state()
	
	state_changed_event.emit(state)


func on_piece_clicked(clicked_piece: PieceLogic, clicked_cell: int):
	if not _can_interact or held_piece != null:
		return
	if _current_state == play_state:
		if clicked_piece.isBlocker:
			return
	# only allow pieces to be interacted if level is the top screen
	if myScreen.screenManager.IsTopScreen(myScreen) == false:
		return
	
	held_piece = clicked_piece
	held_piece_cell = clicked_cell
	
	# move to the forefront
	grid.move_child(grid.get_child(held_piece.get_index()), -1)
	
	clicked_piece.play_grab_audio()
	_remove_occupied_cells(held_piece)

func spawn_piece(pieceID : String):
	if not _can_interact or held_piece != null:
		return
		
	held_piece = grid.LoadPiece(pieceID)
	held_piece_cell = 0
	held_piece.global_position = get_global_mouse_position()

func _ready():
	_gm = get_node(GameMaster.GLOBAL_GAME_MASTER_NODE)
	
	# State
	_current_state = empty_state
	empty_state.set_manager(self)
	play_state.set_manager(self)
	win_state.set_manager(self)
	edit_state.set_manager(self)
	test_state.set_manager(self)
	overPieceLibrary = false

func _process(delta):
	if not _is_inititialized:
		_is_inititialized = true
		
		initialized_event.emit()
		
		_levelData = myScreen.transitionData[LevelsSelectMenu.PASS_LEVEL_DATA_KEY]
		if _levelData != null:
			switch_to_play_state()
			grid.LoadLevel(_levelData)
			_setup_level_labels()
			
			if _levelData.tutorialData != null:
				myScreen.ScreenEnter.connect(_show_tutorial)
		else:
			switch_to_edit_state()
			_setup_level_labels()
	
	if not _can_interact or held_piece == null:
		deletionZone.hide()
		return
		
	if myScreen.screenManager.IsTopScreen(myScreen) == false:
		return
	
	if _current_state is GameEditState:
		deletionZone.show()
	
	_held_piece_towards_cursor(delta)
	if !placing_piece:
		_rotate_held_piece()
	_do_place_held_piece(delta)

func _setup_level_labels():
	var labelSticker : Control = levelNameText.get_parent() as Control
	if _levelData == null or _levelData.levelName.is_empty():
		labelSticker.visible = false
	else:
		labelSticker.visible = true
		levelNameText.text = _levelData.levelName
	
	labelSticker = authorText.get_parent() as Control
	if _levelData == null or _levelData.author.is_empty():
		labelSticker.visible = false
	else:
		labelSticker.visible = true
		authorText.text = str("By: ", _levelData.author)

func _show_tutorial():
	myScreen.ScreenEnter.disconnect(_show_tutorial)
	var tutorialData = _levelData.tutorialData
	if _levelData.tutorialData.displayPieces.size() > 0:
		myScreen.ShowDisplayPopup(tutorialData.title, tutorialData.body, tutorialData.displayPieces)
	else:
		myScreen.ShowTextPopup(tutorialData.title, tutorialData.body)

func _remove_occupied_cells(piece: PieceLogic):
	if piece.current_placement_state != PieceLogic.PlacementStates.PLACED:
		return
	grid.RemovePieceByCoordinates(piece.placed_grid_position)

func _get_held_piece_target_vector() -> Vector2:
	var target_position: Vector2 = retrieve_mouse_position()
	if not grid.CheckIfOffGridPos(target_position):
		target_position = grid.GridCoordinateToPosition(grid.PositionToGridCoordinate(target_position))
	return held_piece.target_vector(target_position, held_piece_cell)
	
func _get_held_piece_target_origin(lastMousePos : Vector2) -> Vector2:
	return lastMousePos - held_piece.origin_to_cell(held_piece_cell)

func _held_piece_towards_cursor(delta):	
	var held_piece_to_mouse: Vector2 = _get_held_piece_target_vector()
	var held_piece_to_mouse_distance: float = held_piece_to_mouse.length()
	
	var distance_step: float = (held_piece_flat_speed + held_piece_distance_speed * held_piece_to_mouse_distance) * delta
	if distance_step > held_piece_to_mouse_distance:
		held_piece.global_position += held_piece_to_mouse
		return
	held_piece.global_position += held_piece_to_mouse.normalized() * distance_step

func _rotate_held_piece():
	if Input.is_action_just_pressed("RotateClockwise"):
		held_piece.rotate_clockwise(held_piece_cell)
		held_piece.play_rotate_audio()
	elif Input.is_action_just_pressed("RotateAnticlockwise"):
		held_piece.rotate_anticlockwise(held_piece_cell)
		held_piece.play_rotate_audio()

func _mouse_has_moved() -> bool:
	var mouse_position : Vector2 = retrieve_mouse_position()
	var mouse_distance_moved : float = (mouse_position - previous_mouse_position).length()
	previous_mouse_position = mouse_position
	return mouse_distance_moved > 0.01 # Has the mouse position changed beyond floating point errors?

func _get_held_piece_grid_origin() -> Vector2i:
	return grid.PositionToGridCoordinate(held_piece.GetOriginCellPosition())

func _held_piece_placed_position(held_piece_grid_origin: Vector2i) -> Vector2:
	var placed_position : Vector2 = grid.GridCoordinateToPosition(held_piece_grid_origin)
	placed_position -= held_piece.GetOriginCellGoalOffset()
	return placed_position

func _do_place_held_piece(delta):
	if !placing_piece:
		# Try to place the held piece
		if !Input.is_action_just_released("PlacePiece"):
			return # Place piece input was not given
		if held_piece == null:
			return # There is no held piece to place

		#Prevents rotation while the timer is running
		placing_piece = true
		placing_locked_position = get_global_mouse_position()
		remaining_placing_delay = place_piece_delay
	else:
		if held_piece == null:
			placing_piece = false
			return # There is no held piece to place
			
		remaining_placing_delay -= delta
		if remaining_placing_delay > 0:
			return
		
		var target_origin : Vector2 = _get_held_piece_target_origin(placing_locked_position)
		var held_piece_grid_origin : Vector2i = grid.PositionToGridCoordinate(target_origin)
		
		# check if the grid can accommodate the held piece
		if grid.CheckLegalToPlaceAtCoords(held_piece, held_piece_grid_origin) == false:
			if _current_state is GameEditState:
				if grid.CheckIfInDeletionZone(held_piece):
					grid.DeletePiece(held_piece)
				else:
					held_piece.return_piece()
			else:
				# Moving the piece around like organizing a jigsaw puzzle
				if grid.CheckIfOffGrid(held_piece) and grid.CheckIfOutsideSafeZone(held_piece) == false:
					held_piece._SetReturnPoint()
				held_piece.return_piece()
			held_piece = null
			placing_piece = false
			return # Piece does not fit
		
		# Find the grid aligned position on screen to move the placed piece to
		var placed_position : Vector2 = _held_piece_placed_position(held_piece_grid_origin)
		held_piece.place_piece(held_piece_grid_origin, placed_position)
		held_piece.play_place_audio()
		held_piece = null # Piece is no longer being held
		placing_piece = false

func get_fauna_frequency():
	return _gm.audio_controller._prefs.freq
	
