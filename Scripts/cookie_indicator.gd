extends TextureButton
var dragging = false
var homePosition:Vector2;
var dragged_button = null
@export var action_name: String = "n/a"

@onready var mainScn = get_tree().get_root().get_node("ScnMain");
var posTween = create_tween();

func _ready() -> void:
	visible = false;
	homePosition = position;

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and get_global_rect().has_point(event.position):
			dragging = true
			dragged_button = self
		elif not event.pressed:
			if dragging:
				dragging = false
				if posTween:
					posTween.kill() # Abort the previous animation.
				posTween = create_tween();
				posTween.tween_property(self, "position", position, .1);
				posTween.tween_property(self, "position", homePosition, (position - homePosition).length()/5000);
			if dragged_button == self:
				mainScn.buttonDragFinished.emit(name);
			dragged_button = null
	if event is InputEventMouseMotion and dragging:
		global_position = get_global_mouse_position() + Vector2(10,10)
