extends Control

@onready var sound = $"Menu Sound";
var okSFX = preload("res://Audio/SFX/V2/UI/Okay.wav");
var mouseOverSFX = preload("res://Audio/SFX/V2/UI/MouseOver.wav");
var enterMenuSFX = preload("res://Audio/SFX/V2/UI/EnterWindow.wav");
var exitMenuSFX = preload("res://Audio/SFX/V2/UI/ExitWindow.wav");
var cancelSFX = preload("res://Audio/SFX/V2/UI/Cancel.wav");
var startGameSFX = preload("res://Audio/SFX/V2/UI/StartGame.wav");

var restartOnSoundFinished = false;

var queuedSound = 0;

func _ready() -> void:
	visible = false;

func resume():
	get_tree().paused = false;
	visible = false;
	
func pause():
	get_tree().paused = true;
	sound.stream = enterMenuSFX;
	sound.play()
	visible = true;

func testEsc():
	if Input.is_action_just_pressed("esc"):
		if get_tree().paused:
			resume()
			sound.stream = exitMenuSFX;
			sound.play()
		else:
			pause()

func _on_hover_over():
	sound.stream = mouseOverSFX;
	sound.play();
			
func _on_resume_pressed() -> void:
	resume()
	sound.stream = exitMenuSFX;
	sound.play()

func _on_restart_pressed() -> void:
	resume()
	sound.stream = startGameSFX;
	sound.play()
	restartOnSoundFinished = true;
	get_parent().get_parent().fadeOut(startGameSFX.get_length() * 1000)


func _on_settings_pressed() -> void:
	sound.stream = okSFX;
	sound.play()

func _on_quit_pressed() -> void:
	get_tree().quit()

func _process(delta: float) -> void:
	testEsc()
	if(restartOnSoundFinished && !sound.playing):
		get_tree().reload_current_scene()
