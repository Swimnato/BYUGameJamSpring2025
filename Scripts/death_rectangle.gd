extends ColorRect

@export var fadedAlpha = 1;
@export var fullyVisibleAlpha = 0;
@export var fadeSpeed = 5;
@export var blackoutLen = 500;

var fadingScreen:bool = false;
var inBlackoutPhase = false;
var fadingIn = false
var screenAlpha = fullyVisibleAlpha;
var lastBlackedOut = 0;

func _ready():
	$"../Player".PlayerDied.connect(_on_player_death)

func _process(delta):
	size = DisplayServer.screen_get_size();
	visible = fadingScreen;
	if(fadingIn):
		screenAlpha -= fadeSpeed * delta;
		if(screenAlpha <= fullyVisibleAlpha):
			fadingIn = false;
			screenAlpha = fullyVisibleAlpha;
			fadingScreen = false;
			inBlackoutPhase = false;
			$"../Player".wakeUp();
		set_color(Color(0,0,0,screenAlpha));
	elif(inBlackoutPhase):
		if(Time.get_ticks_msec() - lastBlackedOut >= blackoutLen):
			fadingIn = true;
	elif(fadingScreen):
		screenAlpha += fadeSpeed * delta;
		if(screenAlpha >= fadedAlpha):
			screenAlpha = fadedAlpha;
			inBlackoutPhase = true;
			lastBlackedOut = Time.get_ticks_msec();
			$"../Player".teleportToRespawn();
		set_color(Color(0,0,0,screenAlpha));


func _on_player_death():
	print("Player Died");
	fadingScreen = true;
	screenAlpha = fullyVisibleAlpha;
	set_color(Color(255,0,0,screenAlpha));
