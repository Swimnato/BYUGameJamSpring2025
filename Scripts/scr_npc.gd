extends Node3D

@export var text = "Howdy Partner!";

func _on_area_3d_body_entered(body: Node3D) -> void:
	if(body.name == "Player"):
		print("Todo: Dialog   " + text);
		body.stop_and_face_npc(self, text);
