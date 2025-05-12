extends CanvasLayer

@onready var mainScn = get_tree().get_root().get_node("ScnMain");

func _ready() -> void:
	mainScn.disableButton.connect(_disableButton);
	mainScn.enableButton.connect(_enableButton);


func _disableButton(button:String):
	print("Disabling buttons: " + button)
	for child in get_child(0).get_children():
		print("Child name: " + child.name)
		if(button == child.name):
			child.visible = false;
			print("found input, deleting: " + child.action_name)
			InputMap.erase_action(child.action_name);
			break;

func _enableButton(button:String):
	for child in get_children():
		if(button == child.name):
			child.visible = true;  
			InputMap.add_action(child.action_name);var button_event = InputEventKey.new()
			if child.action_name == "move_up":  # Example check, customize for each button
				button_event.keycode = KEY_W
				InputMap.action_add_event(child.action_name, button_event) 
				print("Rebound W key to action: ", child.action_name)
			elif child.action_name == "jump":
				button_event.keycode = KEY_SPACE
				InputMap.action_add_event(child.action_name, button_event) 
				print("Rebound space key to action: ", child.action_name)
			elif child.action_name == "move_down":
				button_event.keycode = KEY_S
				InputMap.action_add_event(child.action_name, button_event) 
				print("Rebound space key to action: ", child.action_name)
			elif child.action_name == "move_left":
				button_event.keycode = KEY_A
				InputMap.action_add_event(child.action_name, button_event) 
				print("Rebound space key to action: ", child.action_name)
			elif child.action_name == "move_right":
				button_event.keycode = KEY_D
				InputMap.action_add_event(child.action_name, button_event) 
				print("Rebound space key to action: ", child.action_name)
			print("Button ", child.name, " re-enabled successfully.")
			break;
