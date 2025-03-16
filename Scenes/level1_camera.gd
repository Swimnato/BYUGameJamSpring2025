extends Camera3D

var toLookAt:Vector3;

func _ready() -> void:
	position = Vector3(0,5,10);

func _process(delta: float):
	toLookAt = $"../Player".playerPosition;
	var swap = toLookAt.x;
	toLookAt.x = toLookAt.z;
	toLookAt.z = -swap;
	look_at(toLookAt);
