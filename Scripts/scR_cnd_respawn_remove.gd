extends Node3D


func _on_trigger_zone_body_entered(body: Node3D) -> void:
	if(body.name == "Player"):
		body.disableSpecifiedRespawn();
