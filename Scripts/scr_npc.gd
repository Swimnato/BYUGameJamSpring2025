extends Node3D

@export var cooldown = 1;  # Cooldown for speaking to NPC in seconds
@export_file("*.json") var d_file; #dialogue file to read from
@export var NPC_Mesh:Mesh;

var lastTimeSpokenTo = 0;  # Keeps track of the last time the player spoke to the NPC
var speed;
var current_state = IDLE;
var prev_mesh:Mesh;

var player;
var player_in_chat_zone = false;

enum {
	IDLE,
	NEW_DIR,
	MOVE
}

func _ready() -> void:
	$Dialogue.connect("dialogue_finished", Callable(self, "_on_dialogue_dialogue_finished"));

func _process(delta: float) -> void:
	if(prev_mesh != NPC_Mesh):
		prev_mesh = NPC_Mesh;
		$MeshInstance3D.mesh = NPC_Mesh;
	if Input.is_action_just_pressed("chat") and player_in_chat_zone:
		if lastTimeSpokenTo == 0 or Time.get_ticks_msec() - lastTimeSpokenTo >= cooldown * 1000:
			print("chatting with npc");
			$Dialogue.start();  # Start the dialogue if the cooldown has passed
			lastTimeSpokenTo = Time.get_ticks_msec();  # Update the last time spoken to NPC
			current_state = IDLE;
		else:
			var remaining_time = cooldown - (Time.get_ticks_msec() - lastTimeSpokenTo) / 1000;
			print("You must wait " + str(remaining_time) + " more seconds to chat with the NPC.");
		
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		player_in_chat_zone = true;
		$TalkPrompt.visible = true;

func _on_speaking_zone_body_exited(body: Node3D) -> void:
	if body.name == "Player":
		player_in_chat_zone = false;
		$TalkPrompt.visible = false;

func _on_dialogue_dialogue_finished() -> void:
	print('Dialogue finished')
	lastTimeSpokenTo = Time.get_ticks_msec();
