extends Node3D

var respawnPoints:Array = [];

signal buttonDragFinished(buttonID:String);
signal disableButton(buttonID:String);
signal enableButton(buttonID:String);

func _ready():
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
