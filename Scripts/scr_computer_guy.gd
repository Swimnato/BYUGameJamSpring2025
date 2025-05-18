extends CharacterBody3D

@onready var npcMain = get_parent();
@onready var animations = $NPC_clerk/AnimationPlayer;
@onready var mainScn = get_tree().get_root().get_node("ScnMain");
@onready var dialogueManager = $"../Dialogue";
var lastState = null;
var selected = false;

var queueSelectedOff = false;
var secondsToTurnSelectedOff:float = 0.0;
var hasThankedPlayer = false;
var playerHasStamp = false;
var hasTakenKey = false;

func _ready():
	mainScn.buttonDragFinished.connect(_checkTradeOffer);
	npcMain.playerTradedSuccessfully.connect(_take_key);
	mainScn.playerDied.connect(_playerDied);

func _process(delta):
	if queueSelectedOff and secondsToTurnSelectedOff <= 0:
		queueSelectedOff = false;
		selected = false;
	elif secondsToTurnSelectedOff > 0:
		secondsToTurnSelectedOff -= delta;
	if((npcMain.animationState != lastState && animations.current_animation != "cookie_kid_big_jump") || animations.current_animation == "[Stop]"):
		lastState = npcMain.animationState;
		if(npcMain.animationState == npcMain.animationStates.TALK_TO_PLAYER):
			stop_and_face_player()
			animations.play("clerk_talk");
		elif(npcMain.animationState == npcMain.animationStates.IDLE):
			rotateBackToCounter()
			animations.play("clerk_idle");

func _checkTradeOffer(item:String):
	print(selected);
	print(npcMain.player_in_chat_zone);
	if(!playerHasStamp && !hasTakenKey && selected && (item == "Wkey" || item == "Akey" || item == "Skey" || item == "Dkey") && npcMain.player_in_chat_zone):
		hasTakenKey = true;
		mainScn.disableButton.emit(item);
		npcMain._on_transaction_complete();
		dialogueManager.stop_dialogue();
		dialogueManager.d_file = "res://Dialogue/computer_guy_start_challenge.json";
		npcMain.startDialogue();


func _take_key():
	GameController.open_doors()


func rotateBackToCounter():
	var rotate_tween = create_tween();
	rotate_tween.tween_property(self, "rotation_degrees:y", 0 , 0.5);


func stop_and_face_player():
	var playerPos = npcMain.playerBody.global_position
	var npcPos = npcMain.global_position
	var positionToPlayer = playerPos - npcPos
	var rotationToPlayer = atan2(positionToPlayer.x, positionToPlayer.z);
	var rotate_tween = create_tween();
	rotate_tween.tween_property(self, "rotation:y", rotationToPlayer , 0.5);


func _on_scn_npc_mouse_over_status(over: bool) -> void:
	if over:
		selected = over;
	else:
		queueSelectedOff = true;
		secondsToTurnSelectedOff = .1

func isStampCollected():
	playerHasStamp = true;
	hasTakenKey = false;
	dialogueManager.d_file = "res://Dialogue/computer_guy_post_stamp.json";
	#npcMain.startDialogue();

func _playerDied():
	if(!playerHasStamp):
		dialogueManager.d_file = "res://Dialogue/computer_guy.json";
		hasTakenKey = false;


func _on_dialogue_dialogue_finished() -> void:
	if(playerHasStamp):
		dialogueManager.d_file = "res://Dialogue/computer_guy_sales_pitch.json";
