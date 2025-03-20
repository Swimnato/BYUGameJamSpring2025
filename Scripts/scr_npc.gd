extends Node3D

@export var text = "Howdy Partner!";
@export var cooldown = 5; #cooldown for speaking to NPC

var lastTimeSpokenTo = 0;
var speed;
var current_state = IDLE;


var is_chatting = false;
var player;
var player_in_chat_zone = false;
enum{
	IDLE,
	NEW_DIR,
	MOVE
}
func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("chat") && (player_in_chat_zone)):
		print("chatting with npc");
		$Dialogue.start();
		is_chatting = true;
		current_state = IDLE;
		

func _on_area_3d_body_entered(body: Node3D) -> void:
	if(body.name == "Player" && (lastTimeSpokenTo == 0 || Time.get_ticks_msec() - lastTimeSpokenTo >= cooldown * 1000)):
		player_in_chat_zone = true;
		lastTimeSpokenTo = Time.get_ticks_msec();
		print("Todo: Dialog   " + text);
		body.stop_and_face_npc(self, text);
		


func _on_speaking_zone_body_exited(body: Node3D) -> void:
	if(body.name == "Player"):
		player_in_chat_zone = false;
		


func _on_dialogue_dialogue_finished() -> void:
	is_chatting = false;
