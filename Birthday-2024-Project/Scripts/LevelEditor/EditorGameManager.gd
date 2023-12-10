extends GameManager
class_name EditorGameManager

var overPieceLibrary : bool

func _initialize():
	grid.LoadLevel(debug_setupData)
	overPieceLibrary = false

#can pick up blocker pieces
func on_piece_clicked(clicked_piece: PieceLogic):
	if held_piece != null:
		return
	
	held_piece = clicked_piece
	_remove_occupied_cells(held_piece)
	_reset_settled()

func _do_place_held_piece():
	# Try to place the held piece
	if !Input.is_action_just_released("PlacePiece"):
		return # Place piece input was not given
	if held_piece == null:
		return # There is no held piece to place
	
	#TODO: check if you are over the piece library
	
	# check if the grid can accommodate the held piece
	if grid.CheckLegalToPlace(held_piece) == false:
		held_piece.return_piece()
		held_piece = null
		return # Piece does not fit
	
	# Find the grid aligned position on screen to move the placed piece to
	var held_piece_grid_origin : Vector2i = _get_held_piece_grid_origin()
	var placed_position : Vector2 = _held_piece_placed_position(held_piece_grid_origin)
	held_piece.place_piece(held_piece_grid_origin, placed_position)
	held_piece = null # Piece is no longer being held
