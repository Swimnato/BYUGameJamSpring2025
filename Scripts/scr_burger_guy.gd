extends CharacterBody3D

@onready var npcMain = get_parent();
@onready var animations = $NPC_burger_guy/AnimationPlayer;
var lastState = null;

func _ready():
	npcMain.playerTradedSuccessfully.connect(_give_burger);

func _process(delta):
	if((npcMain.animationState != lastState && animations.current_animation != "cookie_kid_big_jump") || animations.current_animation == "[Stop]"):
		lastState = npcMain.animationState;
		if(npcMain.animationState == npcMain.animationStates.TALK_TO_PLAYER):
			stop_and_face_player()
			animations.play("burger_guy_talk");
		elif(npcMain.animationState == npcMain.animationStates.IDLE):
			rotateBackToCounter()
			animations.play("burger_guy_idle");
		
				
func _give_burger():
	pass; #give player the burger
	
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
