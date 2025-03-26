extends Control
#var key_dropped = false
#func _ready() -> void:
	#for button in get_tree().get_nodes_in_group("draggable_buttons"):
		#button.dropped.connect(_on_button_dropped)
		#
#func handle_drop(): 
	#for button in get_tree().get_nodes_in_group("draggable_buttons"):
		#button.dropped.connect(_on_button_dropped)
#func handle_collision():
	#
