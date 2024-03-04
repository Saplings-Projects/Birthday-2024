extends Node
class_name UISoundPlayer

func _ready():
	# when _ready is called, there might already be nodes in the tree, so connect all existing buttons
	connect_buttons(get_tree().root)
	get_tree().connect("node_added", _on_SceneTree_node_added)

func _on_SceneTree_node_added(node):
	if node is BaseButton:
		connect_to_button(node)
	elif node is TabContainer:
		connect_to_tab(node)

func _on_Button_pressed():
	$ButtonSound.play()
	
func _on_Tab_pressed(index : int):
	$ButtonSound.play()

# recursively connect all buttons
func connect_buttons(root):
	for child in root.get_children():
		if child is BaseButton:
			connect_to_button(child)
		elif child is TabContainer:
			connect_to_tab(child)
		connect_buttons(child)

func connect_to_button(button):
	button.connect("pressed", _on_Button_pressed)

func connect_to_tab(tab):
	tab.connect("tab_clicked", _on_Tab_pressed)
