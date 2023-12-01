class_name GridSpaceInfo

enum GridSpaceStatus {
	OPEN,
	OCCUPIED,
	CLOSED #blocked or unused
}

var currentStatus : GridSpaceStatus
var occupyingPiece : PieceLogic
var gridPosition : Vector2i
var levelGridReference : GridLogic
