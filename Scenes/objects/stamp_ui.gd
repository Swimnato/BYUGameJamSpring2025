extends Control

@onready var label = $Label

func _ready() -> void:
	EventController.connect("stamp_collected", on_event_stamp_collected)
	
func on_event_stamp_collected(value: int)->void:
	label.text = str(value)
