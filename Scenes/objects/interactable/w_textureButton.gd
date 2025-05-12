extends TextureButton
@export var action_name: String = "move_up"
var dragging = false
#var drag_offset = Vector2()
var is_lit = false
var normal_texture: Texture
var pressed_texture: Texture
var dragged_button = null
var homePosition:Vector2;
signal dropped(button, position)

@onready var mainScn = get_tree().get_root().get_node("ScnMain");
var posTween = create_tween();

func _ready() -> void:
	normal_texture = get_texture_normal()
	pressed_texture  = get_texture_pressed()
	texture_normal = normal_texture
	texture_pressed = pressed_texture
	homePosition = position;


func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and get_global_rect().has_point(event.position):
			dragging = true
			dragged_button = self
			print('dragged button: ', dragged_button)
			#drag_offset = event.position - position
		elif not event.pressed:
			if dragging:
				dragging = false
				#position = homePosition;
				if posTween:
					posTween.kill() # Abort the previous animation.
				posTween = create_tween();
				posTween.tween_property(self, "position", position, .1);
				posTween.tween_property(self, "position", homePosition, (position - homePosition).length()/5000);
			if dragged_button == self:
				#print('going to emit signal dragged button: ', dragged_button)
				#dropped.emit(dragged_button, global_position)
				mainScn.buttonDragFinished.emit(name);
			dragged_button = null
	if event is InputEventMouseMotion and dragging:
		global_position = get_global_mouse_position() + Vector2(10,10)
#func _gui_input(event):
	#if event is InputEventMouseButton:
		#if event.button_index == MOUSE_BUTTON_LEFT:
			#if event.pressed:
				#dragging = true
				#dragged_button = self
				#print('dragged button: ', dragged_button);
				#drag_offset = event.position - position
			#else:
				## Stop dragging when released
				#dragging = false
				#dragged_button = null
				
func _process(delta):
	#if dragging and dragged_button == self:
		#position = get_global_mouse_position() - drag_offset
	#else:
		if Input.is_action_pressed(action_name):
			button_press()
			is_lit = true
		elif is_lit: 
			button_not_pressed()
			is_lit = false
		


func button_press() -> void:
	if not dragging:
		self.texture_normal = pressed_texture
		self.texture_pressed = pressed_texture

func button_not_pressed() -> void:
	if not dragging:
		self.texture_normal = normal_texture
		self.texture_pressed = pressed_texture
