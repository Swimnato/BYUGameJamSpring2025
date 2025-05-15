extends CharacterBody3D

@onready var npcMain = get_parent();
@onready var animations = $"NPC_cookie kid/AnimationPlayer";
@onready var mainScn = get_tree().get_root().get_node("ScnMain");
var lastState = null;
var done = false;
var selected = false;

@onready var dialogueManager = $"../Dialogue";
var queueSelectedOff = false;
var secondsToTurnSelectedOff:float = 0.0;
var hasThankedPlayer = false;
var hasGivenCookie = false;

func _ready():
	npcMain.playerTradedSuccessfully.connect(_superJump);
	rotation_degrees = Vector3(0,180,0);
	mainScn.buttonDragFinished.connect(_checkTradeOffer);

func _process(delta):
	if queueSelectedOff and secondsToTurnSelectedOff <= 0:
		queueSelectedOff = false;
		selected = false;
	elif secondsToTurnSelectedOff > 0:
		secondsToTurnSelectedOff -= delta;
	if(done and animations.current_animation != "cookie_kid_big_jump"):
		stop_and_face_player();
	if((npcMain.animationState != lastState && animations.current_animation != "cookie_kid_big_jump") || !animations.is_playing()):
		lastState = npcMain.animationState;
		if(npcMain.animationState == npcMain.animationStates.TALK_TO_PLAYER || done):
			stop_and_face_player()
			animations.play("cookie_kid_idle");
			if(!hasThankedPlayer && done):
				print("thanking players")
				hasThankedPlayer = true;
				npcMain.startDialogue();
		elif(npcMain.animationState == npcMain.animationStates.IDLE):
			rotateBackToTree()
			animations.play("cookie_kid_jump");


func _checkTradeOffer(item:String):
	if(selected && item.to_lower().contains("space") && npcMain.player_in_chat_zone):
		dialogueManager.d_file = "res://Dialogue/Cookie_Kid_Post_Trade.json";
		dialogueManager.stop_dialogue();
		mainScn.disableButton.emit(item);
		npcMain._on_transaction_complete();
		npcMain.playerBody.stop_and_face_npc(self);

func _superJump():
	rotateBackToTree()
	animations.play("cookie_kid_big_jump");
	done = true;

func rotateBackToTree():
	var rotate_tween = create_tween();
	rotate_tween.tween_property(self, "rotation_degrees:y", 180 , 0.5);

func stop_and_face_player():
	if npcMain.playerBody != null:
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


func _on_dialogue_dialogue_finished() -> void:
	if(done && !hasGivenCookie):
		hasGivenCookie = true;
		dialogueManager.d_file = "res://Dialogue/Cookie_Kid_Post_Gift.json";
		mainScn.enableButton.emit("CookieIndicator");
