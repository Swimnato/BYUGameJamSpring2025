extends Node3D

@export var cooldown = 1;  # Cooldown for speaking to NPC in seconds
@export_file("*.json") var d_file; #dialogue file to read from
@export var NPC_Mesh:Mesh;

@export var jumping:bool = false;
@export var jumpingVelocity = 10;
@export var fall_acceleration = 75
@export var jump_delay = 1000;


@onready var NPC_Body = $CharacterBody3D;

var lastTimeJumped = 0;
var lastTimeSpokenTo = 0;  # Keeps track of the last time the player spoke to the NPC
var speed;
var current_state = IDLE;
var prev_mesh:Mesh;

var player;
var playerBody;
var player_in_chat_zone = false;
var player_too_close = false;

enum {
	IDLE,
	NEW_DIR,
	MOVE
}

func _ready() -> void:
	$Dialogue.connect("dialogue_finished", Callable(self, "_on_dialogue_dialogue_finished"));

func _process(delta: float) -> void:
	if(jumping):
		if not NPC_Body.is_on_floor():
			NPC_Body.velocity.y = NPC_Body.velocity.y - (fall_acceleration * delta)
		elif(abs(Time.get_ticks_msec() - lastTimeJumped) >= jump_delay and !$Dialogue.d_active and !player_too_close):
			lastTimeJumped = Time.get_ticks_msec();
			NPC_Body.velocity = Vector3(0, jumpingVelocity, 0);
		else:
			NPC_Body.position = Vector3(0,1,0);
		NPC_Body.move_and_slide()
	if(prev_mesh != NPC_Mesh):
		prev_mesh = NPC_Mesh;
		$CharacterBody3D/MeshInstance3D.mesh = NPC_Mesh;
	if Input.is_action_just_pressed("chat") and player_in_chat_zone:
		if lastTimeSpokenTo == 0 or Time.get_ticks_msec() - lastTimeSpokenTo >= cooldown * 1000:
			$Dialogue.start();  # Start the dialogue if the cooldown has passed
			lastTimeSpokenTo = Time.get_ticks_msec();  # Update the last time spoken to NPC
			current_state = IDLE;
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


func _on_no_jump_region_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		player_too_close = true;


func _on_no_jump_region_body_exited(body: Node3D) -> void:
	if body.name == "Player":
		player_too_close = false;
