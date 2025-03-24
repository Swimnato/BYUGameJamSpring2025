extends AudioStreamPlayer

enum musicTrack {
	OUTSIDE,
	COMPUTER_STORE,
	GYM
}
var musicList:Array = [preload("res://Audio/Music/Song2Loop.wav"), preload("res://Audio/Music/Song1Loop.wav")];
var currentSong = 0;
var prevSong;
var lastAttempt = 0;
var delayAttempt = 100;
var volume = -20;
@export var shouldPlay = true;
@onready var player = $"../Player";

func _ready():
	volume_db = volume;

func _process(delta: float) -> void:
	if(player.floorType == player.surfaceType.GRASS or player.floorType == player.surfaceType.LILLYPAD):
		currentSong = musicTrack.OUTSIDE;
	else:
		currentSong = musicTrack.COMPUTER_STORE;
	if((!playing or prevSong != currentSong) and shouldPlay):
		if(playing):
			stop();
		prevSong = currentSong;
		stream = musicList[currentSong];
		play()
