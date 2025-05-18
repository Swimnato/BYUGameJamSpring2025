extends Node3D

var respawnPoints:Array = [];

signal buttonDragFinished(buttonID:String);
signal disableButton(buttonID:String);
signal enableButton(buttonID:String);
signal resetDisabledButtons();
signal playerDied;
signal fadeAndTeleport(pos:Vector3);

func _ready():
	$Player.PlayerDied.connect(_on_player_death)
	for child in $SubScenes.get_children():
		child.calculatePoints();
		for point in child.respawnPoints:
			#respawnPoints.append(child.position + (point * child.scale))
			respawnPoints.append(point)

func fadeOut(len:int):
	$AudioStreamPlayer.shouldPlay = false;
	$AudioStreamPlayer.stop();
	$deathRectangle.fadingScreen = true;
	$deathRectangle.blackoutLen = len;
	$deathRectangle.screenAlpha = $deathRectangle.fullyVisibleAlpha;

func _on_player_death():
	playerDied.emit();
