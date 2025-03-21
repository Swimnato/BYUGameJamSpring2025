extends CharacterBody3D

@onready var animations: AnimationPlayer = $Pivot/model/AnimationPlayer
signal PlayerDied;

@export var speed = 12
@export var fall_acceleration = 75
@export var jump_force = 30
var target_velocity = Vector3.ZERO
@onready var respawnPoints = get_parent().respawnPoints;

var isBlackedOut = false;
var specificRespawn = false;
var specificRespawnPoint:Node3D;

func _physics_process(delta):
	var direction = Vector3.ZERO
	if(!isBlackedOut):
		direction.x += (1 if Input.is_action_pressed("move_right") and not Input.is_action_pressed("move_left") 
			  else (-1 if Input.is_action_pressed("move_left") and not Input.is_action_pressed("move_right")
			  else 0))
		direction.z += (1 if Input.is_action_pressed("move_down") and not Input.is_action_pressed("move_up") 
			  else (-1 if Input.is_action_pressed("move_up") and not Input.is_action_pressed("move_down")
			  else 0))
	if(direction != Vector3.ZERO):
		direction = direction.normalized()
		$Pivot.basis = $Pivot.basis.slerp(Basis.looking_at(direction), .25)

	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed

	if not is_on_floor():
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)
	elif Input.is_action_pressed("jump"):
		target_velocity.y = jump_force
	handleAnimations(target_velocity)
	velocity = target_velocity
	move_and_slide()
	
func handleAnimations(_target_velocity: Vector3) -> void: 
	if _target_velocity.x || _target_velocity.z != 0:
		animations.current_animation = animations.get_animation_list()[1]
	else: 
		animations.current_animation = animations.get_animation_list()[0]

func die() -> void:
	PlayerDied.emit();
	isBlackedOut = true;
	print("TODO: die");

func respawn():
	isBlackedOut = true;
	
func wakeUp():
	isBlackedOut = false;
	
func teleportToRespawn():
	if !specificRespawn:
		var distanceToEachPoint:Array;
		var indexOfShortest:int = 0;
		var test:Vector3;
		for point in respawnPoints:
			distanceToEachPoint.append((position-point).length_squared());
		var shortestDist:int = distanceToEachPoint[0]
		for distance in range(len(distanceToEachPoint)):
			if distanceToEachPoint[distance] < shortestDist:
				shortestDist = distanceToEachPoint[distance];
				indexOfShortest = distance;
		position = respawnPoints[indexOfShortest];
	else:
		position = get_parent().to_local(specificRespawnPoint.get_parent().get_parent().to_global(specificRespawnPoint.position))

func collect_stamp(ID_num:int):
	print("Collected Stamp: " + str(ID_num))

func stop_and_face_npc(npc:Node3D):
	print("Todo: face NPC, disable physics and input, and maybe zoom camera?");

func setSpecifiedRespawn(point:Node3D):
	specificRespawnPoint = point;
	specificRespawn = true;
	
func disableSpecifiedRespawn():
	specificRespawn = false;
	
