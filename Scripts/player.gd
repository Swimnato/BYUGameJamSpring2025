extends Node3D

@export var maxVelocity:Vector3 = Vector3(15,53.6,15);
@export var airResistance:Vector3 = Vector3(.1,0,.1);
@export var friction:Vector3 = Vector3(2.5,0,2.5);
@export var impulseAmount:int = 3.5;
@export var jumpSpeed = 5;
@export var groundSpeedBonus = 2.5;

@onready var velocity:Vector3 = Vector3(0,0,0);
@onready var acceleration:Vector3 = Vector3(0,-9.8,0);
var oldPosition:Vector3;

var onGround:bool;



# Called when the node enters the scene tree for thssse first time.
func _ready():
	pass

# Called every frame.
func _process(delta):
	if(onGround and velocity.y < 0):
		velocity += acceleration * delta * groundSpeedBonus;
		if(acceleration.x == 0):	
			velocity.x -= friction.x * velocity.x * delta;
		if(acceleration.z == 0):	
			velocity.z -= friction.z * velocity.z * delta;
		oldPosition = position;
	else:
		velocity += acceleration * delta;
	velocity -= airResistance * velocity * delta;
	for i in range(3):
		if(abs(velocity[i]) > maxVelocity[i]):
			if(velocity[i] < 0):
				velocity[i] = -maxVelocity[i];
			else:
				velocity[i] = maxVelocity[i];
	position += velocity * delta;
	if(onGround and oldPosition.y > position.y):
		position.y = oldPosition.y;
	get_parent().playerPosition = position;

func _input(event):
	if event is InputEventKey:
		if event.keycode == KEY_W or event.keycode == KEY_S:
			if event.pressed and event.keycode == KEY_W:
				acceleration.z = impulseAmount;
			elif event.pressed and event.keycode == KEY_S:
				acceleration.z = -impulseAmount;
			else:
				acceleration.z = 0;
		if event.keycode == KEY_A or event.keycode == KEY_D:
			if event.pressed and event.keycode == KEY_A:
				acceleration.x = impulseAmount;
			elif event.pressed and event.keycode == KEY_D:
				acceleration.x = -impulseAmount;
			else:
				acceleration.x = 0;
		if event.pressed and event.keycode == KEY_SPACE:
			velocity.y = jumpSpeed;


func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.name == "Ground":
		onGround = true;


func _on_area_3d_area_exited(area: Area3D) -> void:
	if area.name == "Ground":
		onGround = false;
