extends CharacterBody3D

@onready var npcMain = get_parent();
@onready var animations = $frog2/AnimationPlayer;
var lastState = null;
var done = false;

func _ready():
	npcMain.playerTradedSuccessfully.connect(_eatCookie);

func _process(delta):
	if((npcMain.animationState != lastState && animations.current_animation != "frog_receive_cookie2") || animations.current_animation == "[Stop]"):
		lastState = npcMain.animationState;
		if(done):
			animations.play("frog_receive_cookie");
		elif(npcMain.animationState == npcMain.animationStates.IDLE):
			animations.play("frog_idle");
		
				
func _eatCookie():
	animations.play("frog_receive_cookie2");
	done = true;
