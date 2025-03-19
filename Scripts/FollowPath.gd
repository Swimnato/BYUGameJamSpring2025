extends PathFollow3D

@export var speed = 30;

func ready():
	pass

func _physics_process(delta: float) -> void:
	progress += speed * delta;
