extends TextureButton
@export var action_name: String = "move_up"
var dragging = false
var drag_offset = Vector2()
var is_lit = false
var normal_texture = get_texture_normal()
var pressed_texture  = get_texture_pressed()
func _ready() -> void:
	texture_normal = normal_texture
	texture_pressed = pressed_texture
	
	
# Called when the left mouse button is pressed over the button
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				# Start dragging when clicked
				dragging = true
				drag_offset = event.position - position
			else:
				# Stop dragging when released
				dragging = false

# Called every frame if the button is being dragged
func _process(delta):
	if dragging:
		# Move the button with the mouse position, adjusting by the offset
		position = get_global_mouse_position() - drag_offset
	if Input.is_action_pressed(action_name):
		_on_button_down()
		is_lit = true
	elif is_lit:  # Reset color when "W" key is released
		_on_button_up()
		is_lit = false
		


func _on_button_down() -> void:
	print("Button is pressed!")
	# Set pressed texture explicitly when the button is pressed
	self.texture_normal = pressed_texture


func _on_button_up() -> void:
	print("Button is released!")
	self.texture_normal = normal_texture
