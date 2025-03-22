extends Node3D

@export var ID_num = 0;
@export var turnAmount:float = 20;
@export var turnSpeed = 2;

var angle = 0;
var direction = 1;

var textures = ["res://Visual Assets/Stamps/stamp1.png","res://Visual Assets/Stamps/stamp2.png","res://Visual Assets/Stamps/stamp3.png","res://Visual Assets/Stamps/stamp4.png"];

func _ready():
	turnAmount = turnAmount * PI / 180.0;

func _process(delta):
	rotation.y += direction * delta * turnSpeed;
	if(abs(rotation.y) > turnAmount):
		rotation.y = -turnAmount if direction < 0 else turnAmount;
		direction = -turnAmount if direction > 0 else turnAmount;
		

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		body.collect_stamp(ID_num)
		queue_free();
