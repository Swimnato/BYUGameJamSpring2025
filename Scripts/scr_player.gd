extends CharacterBody3D

@onready var animations: AnimationPlayer = $Pivot/model/AnimationPlayer
signal PlayerDied;

@export var speed = 12
@export var fall_acceleration = 75
@export var frogJump = 0;
@export var jump_force:Array = [20,30]
var target_velocity = Vector3.ZERO
var tread_velocity = Vector3.ZERO
@onready var respawnPoints = get_parent().respawnPoints;

var wasOnFloorLastLoop = true;
enum surfaceType{
GRASS,
LILLYPAD,
COMP_STORE,
GYM
};
var floorType:surfaceType = 0;
var isBlackedOut = false;
var isTalking = false;
var specificRespawn = false;
var specificRespawnPoint:Node3D;
var direction:Vector3;
var location = 0;
var footsteps:Array = [preload("res://Audio/SFX/V2/Player Movements/Outdoor/Grass_Footsteps.wav"),preload("res://Audio/SFX/V2/Player Movements/Outdoor/Lilypad_Footsteps.wav"), preload("res://Audio/SFX/V2/Player Movements/Indoor/ComputerStore_Footsteps.wav"), preload("res://Audio/SFX/V2/Player Movements/Indoor/Gym_Footsteps.wav")];
var landingSound:Array = [[preload("res://Audio/SFX/V2/Player Movements/Outdoor/Grass_Landing1.wav"),preload("res://Audio/SFX/V2/Player Movements/Outdoor/Grass_Landing2.wav")],[preload("res://Audio/SFX/V2/Player Movements/Outdoor/Lilypad_Landing1.wav"),preload("res://Audio/SFX/V2/Player Movements/Outdoor/Lilypad_Landing2.wav"),preload("res://Audio/SFX/V2/Player Movements/Outdoor/Lilypad_Landing3.wav")],[preload("res://Audio/SFX/V2/Player Movements/Indoor/ComputerStore_Landing1.wav"),preload("res://Audio/SFX/V2/Player Movements/Indoor/ComputerStore_Landing2.wav")], [preload("res://Audio/SFX/V2/Player Movements/Indoor/Gym_Landing1.wav"),preload("res://Audio/SFX/V2/Player Movements/Indoor/Gym_Landing2.wav")]];
var splash = preload("res://Audio/SFX/V2/Feedback/Splash.wav");
var splat = preload("res://Audio/SFX/V2/Feedback/Smash.wav")
var stampCollected = preload("res://Audio/SFX/V2/Feedback/Stamp_Collected.wav");
@onready var sfxPlayer = $AudioStreamPlayer;
var jmpSound:Array = [preload("res://Audio/SFX/V2/Player Movements/Standard_Jump.wav"),preload("res://Audio/SFX/V2/Player Movements/Frog_Jump.wav")]

func _physics_process(delta):
	direction = Vector3.ZERO
	if(!isBlackedOut && !isTalking):
		direction.x += (1 if Input.is_action_pressed("move_right") and not Input.is_action_pressed("move_left") 
			  else (-1 if Input.is_action_pressed("move_left") and not Input.is_action_pressed("move_right")
			  else 0))
		direction.z += (1 if Input.is_action_pressed("move_down") and not Input.is_action_pressed("move_up") 
			  else (-1 if Input.is_action_pressed("move_up") and not Input.is_action_pressed("move_down")
			  else 0))
	if(direction != Vector3.ZERO && !isTalking):
		direction = direction.normalized()
		$Pivot.basis = $Pivot.basis.slerp(Basis.looking_at(direction), .25)

	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed

	if not is_on_floor():
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)
	elif Input.is_action_pressed("jump") and !isBlackedOut && !isTalking:
		target_velocity.y = jump_force[frogJump];
		sfxPlayer.stream = jmpSound[frogJump];
		sfxPlayer.play();
	elif(!wasOnFloorLastLoop):
		sfxPlayer.stream = landingSound[floorType][round(randf_range(0,len(landingSound[floorType]) - 1))];
		sfxPlayer.play();
	handleAnimations(target_velocity)
	velocity = target_velocity
	wasOnFloorLastLoop = is_on_floor();
	move_and_slide()
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if(collision.get_collider().name.to_lower().contains("lillypad")):
			floorType = surfaceType.LILLYPAD;
		#elif collision.get_collider().name.contains("tread"):
			#floorType = surfaceType.COMP_STORE
		else:
			floorType = surfaceType.GRASS;
	
func handleAnimations(_target_velocity: Vector3) -> void: 
	if _target_velocity.x || _target_velocity.z != 0:
		animations.current_animation = animations.get_animation_list()[1]
		if(is_on_floor() and !sfxPlayer.playing):
			sfxPlayer.stream = footsteps[floorType];
			sfxPlayer.play()
	else: 
		animations.current_animation = animations.get_animation_list()[0]

func die(src:int = 0) -> void:
	if(src == 0):
		sfxPlayer.stream = splat;
	elif(src == 1):
		sfxPlayer.stream = splash;
	sfxPlayer.play()
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
	sfxPlayer.stream = stampCollected
	sfxPlayer.play();

func stop_and_face_npc(npc:Node3D):
	isTalking = true;
	var positionToNPC = npc.get_parent().get_parent().get_parent().to_global(npc.position) - position
	var rotationToNPC = atan2(-positionToNPC.x, -positionToNPC.z);
	var rotate_tween = create_tween();
	rotate_tween.tween_property($Pivot, "rotation:y", rotationToNPC , 0.5);
	
	

func release_player():
	isTalking = false;

func setSpecifiedRespawn(point:Node3D):
	specificRespawnPoint = point;
	specificRespawn = true;
	
func disableSpecifiedRespawn():
	specificRespawn = false;
	
