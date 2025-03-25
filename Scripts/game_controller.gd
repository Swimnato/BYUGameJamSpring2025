extends Node
var total_stamps:int = 0
var current_hovered_npc = null  # Stores NPC under the mouse
var disabled_buttons = []
var removed_buttons = []
signal transaction_complete()
func _ready():
	# Get all buttons in the scene and connect their signals
	print("hooking up")
	var buttons = get_tree().get_nodes_in_group("draggable_buttons")
	print("Found Buttons in group:", buttons.size())
	
	for button in buttons:
		print("Button:", button.name)  # Print the name of each button
		if button.has_signal("dropped"):
			button.connect("dropped", _on_button_dropped)
			print("Connected dropped signal for", button.name)
		else:
			print("Warning: Button", button.name, "does not have 'dropped' signal!")

	# Get all NPCs and connect their signals
	for npc in get_tree().get_nodes_in_group("npcs"):
		if npc.has_signal("npc_hovered"):
			npc.connect("npc_hovered", _on_npc_hovered)
			print("Connected npc_hovered for", npc.name)
	print("hooked up")	
func stamp_collected(value:int):
	total_stamps += value
	EventController.emit_signal("stamp_collected", total_stamps)
	
func _on_button_dropped(button, position):
	print("_on_button_dropped")
	if current_hovered_npc:
		print("Button ", button.name, " dropped on NPC ", current_hovered_npc.name)
		# Save the button and its action name in the disabled_buttons array
		disabled_buttons.append({"button": button, "action_name": button.action_name})
		# Handle the dropped button interaction (e.g., trigger action on NPC)
		# Step 1: Disable the button
		button.set_process(false)  # Stops it from updating
		button.set_deferred("disabled", true)  # Prevents further interaction
		InputMap.erase_action(button.action_name)
		# Step 2: Remove from UI
		if button.get_parent():  
			var parent = button.get_parent()
			removed_buttons.append({"button": button, "parent": parent})
			button.get_parent().remove_child(button)  # Remove from scene tree
		print("Button ", button.name, " removed and disabled")
		print("resetting buttons")
		#reset_disabled_buttons()
	 	# Emit the signal to notify the NPC that the button was disabled
		transaction_complete.emit()
func _on_npc_hovered(npc):
	print("_on_npc_hovered called for", npc.name)
	current_hovered_npc = npc

func reset_disabled_buttons():
	print("Starting to reset disabled buttons...")

	for item in disabled_buttons:
		var button = item["button"]
		var action_name = item["action_name"]

		print("Re-enabling button: ", button.name, " with action: ", action_name)

		# Re-enable the button
		button.set_process(true)  # Allow it to process input again
		button.set_deferred("disabled", false)  # Enable further interaction
		InputMap.add_action(action_name)  # Restore the action to the InputMap
		print("Added action back: ", action_name)
		
		#rebind
		var button_event = InputEventKey.new()
		if button.action_name == "move_up":  # Example check, customize for each button
			button_event.keycode = KEY_W
			InputMap.action_add_event(action_name, button_event) 
			print("Rebound W key to action: ", action_name)
		elif button.action_name == "jump":
			button_event.keycode = KEY_SPACE
			InputMap.action_add_event(action_name, button_event) 
			print("Rebound space key to action: ", action_name)
		elif button.action_name == "move_down":
			button_event.keycode = KEY_S
			InputMap.action_add_event(action_name, button_event) 
			print("Rebound space key to action: ", action_name)
		elif button.action_name == "move_left":
			button_event.keycode = KEY_A
			InputMap.action_add_event(action_name, button_event) 
			print("Rebound space key to action: ", action_name)
		elif button.action_name == "move_right":
			button_event.keycode = KEY_D
			InputMap.action_add_event(action_name, button_event) 
			print("Rebound space key to action: ", action_name)
		print("Button ", button.name, " re-enabled successfully.")
		
	for data in removed_buttons:
		var button = data["button"]
		var parent = data["parent"]

		# Re-add the button to its original parent
		parent.add_child(button)

		# Optionally, re-enable button interaction
		button.set_process(true)
		button.set_deferred("disabled", false)

		print("Button ", button.name, " re-added to UI")

	# Clear the list after resetting the buttons
	removed_buttons.clear()
	# Clear the disabled_buttons list after resetting
	print("Clearing disabled_buttons list.")
	disabled_buttons.clear()
	print("Reset completed. All buttons re-enabled and list cleared.")
