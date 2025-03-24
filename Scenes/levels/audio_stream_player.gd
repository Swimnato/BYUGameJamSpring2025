extends AudioStreamPlayer

var musicList:Array = [preload("res://Audio/Music/Song2Loop.wav")];
var currentSong = 0;
var prevSong;
var lastAttempt = 0;
var delayAttempt = 100;
var volume = -20;
@export var shouldPlay = true;

func _ready():
	volume_db = volume;

func _process(delta: float) -> void:
	if((!playing or prevSong != currentSong) and shouldPlay):
		print(currentSong);
		prevSong = currentSong;
		stream = musicList[currentSong];
		play()
