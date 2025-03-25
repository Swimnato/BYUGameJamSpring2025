extends Node3D

@onready var tread = $tread

func _process(delta: float) -> void:
	tread.material_override.uv1_offset.x += .0002
