extends AudioStreamPlayer

var musicList:Array = [preload("res://Audio/Song2Loop.mp3")];
var currentSong = 0;
var prevSong;
var lastAttempt = 0;
var delayAttempt = 100;

func _process(delta: float) -> void:
	if((!playing or prevSong != currentSong)):
		print(currentSong);
		prevSong = currentSong;
		stream = musicList[currentSong]
		play()
