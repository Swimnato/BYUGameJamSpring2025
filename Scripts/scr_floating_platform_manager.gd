extends Node3D

@export var progressOffsetRatio:float = 0;

func _ready():
	$Path3D/PathFollow3D.progress_ratio = progressOffsetRatio;
