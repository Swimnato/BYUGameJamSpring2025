extends TextureButton


var dragging = false
var drag_offset = Vector2()
func _input(event):
	if event is InputEventMouseButton:
		if event.pressed and get_global_rect().has_point(event.position):
			dragging = true
			drag_offset = event.position - position
		elif not event.pressed:
			dragging = false

	if event is InputEventMouseMotion and dragging:
		global_position = get_global_mouse_position() - drag_offset
