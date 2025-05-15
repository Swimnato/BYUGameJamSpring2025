extends CharacterBody3D

@onready var npcMain = get_parent();
@onready var animations = $frog2/AnimationPlayer;
@onready var mainScn = get_tree().get_root().get_node("ScnMain");
@onready var dialogueManager = $"../Dialogue";
var lastState = null;
var done = false;
var selected = false;
var hasThankedPlayer = false;
var hasGivenJump = false;

var queueSelectedOff = false;
var secondsToTurnSelectedOff:float = 0.0;

func _ready():
	npcMain.playerTradedSuccessfully.connect(_eatCookie);
	mainScn.buttonDragFinished.connect(_checkTradeOffer);

func _process(delta):
	if queueSelectedOff and secondsToTurnSelectedOff <= 0:
		queueSelectedOff = false;
		selected = false;
	elif secondsToTurnSelectedOff > 0:
		secondsToTurnSelectedOff -= delta;
	if((npcMain.animationState != lastState && animations.current_animation != "frog_receive_cookie2") || !animations.is_playing()):
		lastState = npcMain.animationState;
		if(done):
			animations.play("frog_receive_cookie");
			if(!hasThankedPlayer):
				print("thanking player")
				hasThankedPlayer = true;
				npcMain.startDialogue();
				npcMain.animationState = npcMain.animationStates.TALK_TO_PLAYER;
		elif(npcMain.animationState == npcMain.animationStates.IDLE):
			animations.play("frog_idle");


func _eatCookie():
	animations.play("frog_receive_cookie2");
	done = true;


func _checkTradeOffer(item:String):
	if(selected && item.to_lower().contains("cookie") && npcMain.player_in_chat_zone):
		mainScn.disableButton.emit(item);
		dialogueManager.stop_dialogue();
		npcMain.playerBody.stop_and_face_npc(self);
		dialogueManager.d_file = "res://Dialogue/Frog_Dialogue_Post_Trade.json";
		npcMain._on_transaction_complete();
		

func _on_scn_npc_mouse_over_status(over: bool) -> void:
	if over:
		selected = over;
	else:
		queueSelectedOff = true;
		secondsToTurnSelectedOff = .1


func _on_dialogue_dialogue_finished() -> void:
	print("frog dialogue finished")
	if(hasThankedPlayer && !hasGivenJump):
		hasGivenJump = true;
		print("giving jump")
		mainScn.enableButton.emit("spaceKey");
		npcMain.playerBody.enableFrogJump();
		dialogueManager.d_file = "res://Dialogue/Frog_Dialogue_Post_Gift.json";
