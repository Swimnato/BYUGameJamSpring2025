extends Button
@export var action_name: String = "move_down"
var dragging = false
var drag_offset = Vector2()
var is_lit = false
# Called when the left mouse button is pressed over the button
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				# Start dragging when clicked
				dragging = true
				#drag_offset = event.position - position
			else:
				# Stop dragging when released
				dragging = false

# Called every frame if the button is being dragged
func _process(delta):
	if dragging:
		# Move the button with the mouse position, adjusting by the offset
		position = self.get_global_mouse_position() - drag_offset
	if Input.is_action_pressed(action_name):
		light_up()
		is_lit = true
	elif is_lit:  # Reset color when "W" key is released
		reset_color()
		is_lit = false
		
func _button_down():
	light_up()

# Reset when button is released
func _button_up():
	reset_color()

# Function to change color (light up effect)
func light_up():
	self.modulate = Color(0.8, 0.8, 0.2)  # Yellowish effect

# Function to reset color
func reset_color():
	self.modulate = Color(1, 1, 1)  # Default white color


#func _on_pressed() -> void:
	#dragging = true
	#drag_offset = self.get_global_mouse_position() - position
