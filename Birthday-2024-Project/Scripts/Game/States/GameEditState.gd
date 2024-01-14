class_name GameEditState
extends GameState

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass




#region GameState

func enter_state():
	print("Entering Game Edit State")
	
	manager._can_interact = true


func exit_state():
	print("Exiting Game Edit State")


func update_state():
	pass


#endregion GameState
