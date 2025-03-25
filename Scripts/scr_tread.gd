extends Node3D

@onready var tread = $tread_001
@onready var tread2 = $"weird piece for adams witchcraft/tread_002"

func _process(delta: float) -> void:
	tread.material_override.uv1_offset.x += .002
	tread2.material_override.uv1_offset.x -= .002
