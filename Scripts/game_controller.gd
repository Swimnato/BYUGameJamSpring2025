extends Node
var total_stamps:int = 0
var is_dragging = false
func stamp_collected(value:int):
	total_stamps += value
	EventController.emit_signal("stamp_collected", total_stamps)
func reset_stamp_collected():
	total_stamps = 0
