extends Node3D

@export var text = "Howdy Partner!";
@export var cooldown = 5; #cooldown for speaking to NPC

var lastTimeSpokenTo = 0;

func _on_area_3d_body_entered(body: Node3D) -> void:
	if(body.name == "Player" && (lastTimeSpokenTo == 0 || Time.get_ticks_msec() - lastTimeSpokenTo >= cooldown * 1000)):
		lastTimeSpokenTo = Time.get_ticks_msec();
		print("Todo: Dialog   " + text);
		body.stop_and_face_npc(self, text);
