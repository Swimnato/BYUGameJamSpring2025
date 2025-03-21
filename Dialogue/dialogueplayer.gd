extends Control

@export_file("*.json") var d_file;
signal dialogue_finished;

var dialogue = [] #holds dialogue info
var current_dialogue_id = 0 #keeps track of if theres more left 
var d_active = false #checks if dialogue is still going 
var typing_speed = 0.05  # Speed of text appearing
var full_text = ""  # Stores the complete dialogue text
var displayed_text = ""  # Stores currently displayed portion of text
var typing = false  # Tracks if typing is in progress

func _ready() -> void:
	$NinePatchRect.visible = false #make sure its not seen first
	if not $typing_timer.timeout.is_connected(_on_typing_timer_timeout):#comfirm timeout connection for typing effect
		$typing_timer.timeout.connect(_on_typing_timer_timeout)
		
func start():
	if d_active:
		return
	d_active = true
	$NinePatchRect.visible = true
	dialogue = load_dialogue()
	current_dialogue_id = -1
	next_script()

func load_dialogue():
	var file = FileAccess.open(d_file, FileAccess.READ)
	var content = JSON.parse_string(file.get_as_text())
	return content

func _input(event: InputEvent) -> void:
	if !d_active:
		return
	if event.is_action_pressed("chat"):
		if typing:
			$NinePatchRect/Text.text = full_text
			$typing_timer.stop()
			typing = false
		else:
			next_script()

func next_script():
	current_dialogue_id += 1
	if current_dialogue_id >= len(dialogue):
		d_active = false
		$NinePatchRect.visible = false
		emit_signal("dialogue_finished")
		return
	$NinePatchRect/Name.text = dialogue[current_dialogue_id]['name']
	full_text = dialogue[current_dialogue_id]['text']
	displayed_text = ""
	$NinePatchRect/Text.text = ""
	typing = true
	$typing_timer.start(typing_speed)

func _on_typing_timer_timeout():
	
	if displayed_text.length() < full_text.length():
		displayed_text += full_text[displayed_text.length()]
		$NinePatchRect/Text.text = displayed_text  
	else:
		$typing_timer.stop()
		typing = false
