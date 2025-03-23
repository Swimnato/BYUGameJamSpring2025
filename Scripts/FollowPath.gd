extends PathFollow3D

@export var speed = .05;

func ready():
	pass

func _physics_process(delta: float) -> void:
	progress_ratio += speed * delta;
