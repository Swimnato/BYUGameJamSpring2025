extends Node3D

@export var maxVelocity:Vector3 = Vector3(15,53.6,15);
@export var frictionCoeffiecient:Vector3 = Vector3(1,0,1);
@export var impulseAmount:int = 7;
@export var jumpSpeed = 5;

@onready var velocity:Vector3 = Vector3(0,0,0);
@onready var acceleration:Vector3 = Vector3(0,-9.8,0);



# Called when the node enters the scene tree for thssse first time.
func _ready():
	pass

# Called every frame.
func _process(delta):
	velocity -= frictionCoeffiecient * velocity * delta;
	velocity += acceleration * delta;
	for i in range(3):
		if(abs(velocity[i]) > maxVelocity[i]):
			if(velocity[i] < 0):
				velocity[i] = -maxVelocity[i];
			else:
				velocity[i] = maxVelocity[i];
	position += velocity * delta;

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
