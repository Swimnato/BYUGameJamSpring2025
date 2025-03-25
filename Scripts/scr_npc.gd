extends Node3D

@export var cooldown = 1;  # Cooldown for speaking to NPC in seconds
@export_file("*.json") var d_file; #dialogue file to read from

var lastTimeSpokenTo = 0;  # Keeps track of the last time the player spoke to the NPC
var speed;
var current_state = IDLE;
var prev_mesh:Mesh;

var animationState:animationStates = animationStates.IDLE;
signal playerTradedSuccessfully;
signal playerFailedTrade;

var player;
var playerBody;
var player_in_chat_zone = false;
var player_too_close = false;

enum animationStates {
	IDLE,
	TALK_TO_PLAYER
}

enum {
	IDLE,
	NEW_DIR,
	MOVE
}

func _ready() -> void:
	$Dialogue.connect("dialogue_finished", Callable(self, "_on_dialogue_dialogue_finished"));

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("chat") and player_in_chat_zone:
		if lastTimeSpokenTo == 0 or Time.get_ticks_msec() - lastTimeSpokenTo >= cooldown * 1000:
			$Dialogue.start();  # Start the dialogue if the cooldown has passed
			lastTimeSpokenTo = Time.get_ticks_msec();  # Update the last time spoken to NPC
			current_state = IDLE;
			animationState = animationStates.TALK_TO_PLAYER;
			playerBody.stop_and_face_npc(self);
		else:
			var remaining_time = cooldown - (Time.get_ticks_msec() - lastTimeSpokenTo) / 1000;
		
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		player_in_chat_zone = true;
		playerBody = body;
		$TalkPrompt.visible = true;

func _on_speaking_zone_body_exited(body: Node3D) -> void:
	if body.name == "Player":
		player_in_chat_zone = false;
		$TalkPrompt.visible = false;

func _on_dialogue_dialogue_finished() -> void:
	lastTimeSpokenTo = Time.get_ticks_msec();
	playerBody.release_player()
	animationState = animationStates.IDLE;
	playerTradedSuccessfully.emit();


func _on_no_jump_region_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		player_too_close = true;


func _on_no_jump_region_body_exited(body: Node3D) -> void:
	if body.name == "Player":
		player_too_close = false;
