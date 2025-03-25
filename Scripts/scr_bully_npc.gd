extends CharacterBody3D

@onready var npcMain = get_parent();
@onready var animations = $NPC_bully/AnimationPlayer;
var lastState = null;
var done = false;

func _process(delta):
	if((npcMain.animationState != lastState) || animations.current_animation == "[Stop]"):
		lastState = npcMain.animationState;
		if(npcMain.animationState == npcMain.animationStates.TALK_TO_PLAYER):
			animations.play("bully_talk");
		elif(npcMain.animationState == npcMain.animationStates.IDLE):
			animations.play("bully_idle");
