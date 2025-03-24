extends Node3D

@export var deathID = 0;

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		body.die(deathID);
