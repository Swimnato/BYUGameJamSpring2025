extends Control

@export var action_name: String = "move_up"
var dragging = false
var drag_offset = Vector2()
var is_lit = false
var normal_texture: Texture
var pressed_texture: Texture
var dragged_button = null

@onready var texture_rect = $TextureRect  # Ensure you have a TextureRect inside the Control node

func _ready() -> void:
	normal_texture = texture_rect.texture
	pressed_texture = preload("res://3d Models/objects/pressed_w_key.webp")  # Set a valid texture path
	print("Normal Texture:", normal_texture)
	print("Pressed Texture:", pressed_texture)

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				dragging = true
				dragged_button = self
				print('dragged button: ', dragged_button)
				drag_offset = event.position - position
			else:
				dragging = false
				dragged_button = null
				
func _process(delta):
	if dragging and dragged_button == self:
		position = get_global_mouse_position() - drag_offset

	if Input.is_action_pressed(action_name):
		button_press()
		is_lit = true
	elif is_lit: 
		button_not_pressed()
		is_lit = false

func button_press() -> void:
	print('on button down')
	if not dragging:
		texture_rect.texture = pressed_texture
	print("Texture set to Pressed")

func button_not_pressed() -> void:
	print('on button up')
	if not dragging:
		texture_rect.texture = normal_texture
	print("Texture set to Normal")
