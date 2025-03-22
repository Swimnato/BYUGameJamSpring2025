extends Node
var total_stamps:int = 0
func stamp_collected(value:int):
	total_stamps += value
	EventController.emit_signal("stamp_collected", total_stamps)
