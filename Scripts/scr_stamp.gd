extends Node3D

@export var ID_num = 0;
@export var value: int = 1;
@export var turnAmount:float = 20;
@export var turnSpeed = 2;
@export var personOfInterest:Node3D = null;

signal isCollected;

var angle = 0;
var direction = 1;

const firstStamp = preload("res://materials/BlueStamp.tres")
const secondStamp = preload("res://materials/GreenStamp.tres");
const thirdStamp = preload("res://materials/OrangeStamp.tres");
const fourthStamp = preload("res://materials/RedStamp.tres");

const textures:Array = [firstStamp,secondStamp,thirdStamp,fourthStamp];

func _ready():
	turnAmount = turnAmount * PI / 180.0;
	$imageFront.material_override = textures[ID_num];
	$imageBack.material_override = textures[ID_num];

func _process(delta):
	rotation.y += direction * delta * turnSpeed;
	if(abs(rotation.y) > turnAmount):
		rotation.y = -turnAmount if direction < 0 else turnAmount;
		direction = -turnAmount if direction > 0 else turnAmount;
		

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		body.collect_stamp(ID_num)
		GameController.stamp_collected(value)
		isCollected.emit();
		if(personOfInterest != null):
			body.visitPersonOfInterest(personOfInterest)
		queue_free();
