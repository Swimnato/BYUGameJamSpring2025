extends CharacterBody3D

@onready var animations: AnimationPlayer = $Pivot/goblin_v1/AnimationPlayer
signal PlayerDied;

@export var speed = 12
@export var fall_acceleration = 75
@export var frogJump = 0;
@export var jump_force:Array = [20,30]
var target_velocity = Vector3.ZERO
var tread_velocity = Vector3.ZERO
@onready var respawnPoints = get_parent().respawnPoints;
@onready var mainScn = get_tree().get_root().get_node("ScnMain");

var wasOnFloorLastLoop = true;
enum surfaceType{
GRASS,
LILLYPAD,
COMP_STORE,
GYM
};
var canJump = true;
var hasCookie = false;
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
var waitingToTeleport = false;
var personToVisit:Node3D;
@onready var sfxPlayer = $AudioStreamPlayer;
var jmpSound:Array = [preload("res://Audio/SFX/V2/Player Movements/Standard_Jump.wav"),preload("res://Audio/SFX/V2/Player Movements/Frog_Jump.wav")]

func _physics_process(delta):
	direction = Vector3.ZERO
	if(!isBlackedOut && !isTalking && !waitingToTeleport):
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
	elif Input.is_action_pressed("jump") and !isBlackedOut && !waitingToTeleport && !isTalking && canJump:
		if floorType != surfaceType.COMP_STORE:
			target_velocity.y = jump_force[frogJump];
		else:
			target_velocity.y = jump_force[0];
		sfxPlayer.stream = jmpSound[frogJump];
		sfxPlayer.play();
	elif(!wasOnFloorLastLoop):
		sfxPlayer.stream = landingSound[floorType][round(randf_range(0,len(landingSound[floorType]) - 1))];
		sfxPlayer.play();
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		print(collision.get_collider().name)
		if(collision.get_collider().name.to_lower().contains("lillypad")):
			floorType = surfaceType.LILLYPAD;
			canJump = true;
		elif(collision.get_collider().get_parent().name.to_lower().contains("npc")):
			canJump = false;
		elif collision.get_collider().name.to_lower().contains("door") || collision.get_collider().name.to_lower().contains("wall"):
			pass; #don't change floor type for walls
		elif collision.get_collider().name.to_lower().contains("computer") or collision.get_collider().get_parent().name.to_lower().contains("shelf") or collision.get_collider().get_parent().name.to_lower().contains("box"):
			floorType = surfaceType.COMP_STORE
			canJump = true;
		elif collision.get_collider().get_parent().name.to_lower().contains("tread"):
			floorType = surfaceType.COMP_STORE
			var tread_direction = Vector3.ZERO
			tread_direction = collision.get_collider().get_parent().get_rotation()
			var tdir = round(rad_to_deg(collision.get_collider().get_parent().get_rotation().y))
			if tdir == 0:
				tread_direction.z = 1
			elif tdir == 180 || tdir == -180:
				tread_direction.z = -1
			elif tdir == 90:
				tread_direction.x = 1
			elif tdir == -90:
				tread_direction.x = -1;
			#tread_direction = tread_direction.normalized()
			target_velocity.x += tread_direction.x * speed
			target_velocity.z += tread_direction.z * speed
			canJump = false;
		else:
			floorType = surfaceType.GRASS;	
			canJump = true;
	handleAnimations(target_velocity, is_on_floor())
	velocity = target_velocity
	wasOnFloorLastLoop = is_on_floor();
	move_and_slide()


func handleAnimations(_target_velocity: Vector3, on_floor) -> void: 
	if !on_floor:
		if _target_velocity.y < 0:
			animations.current_animation = animations.get_animation_list()[6];
		else:
			animations.current_animation = animations.get_animation_list()[6];
	elif _target_velocity.x || _target_velocity.z != 0:
		animations.current_animation = animations.get_animation_list()[7]
		if(is_on_floor() and !sfxPlayer.playing):
			sfxPlayer.stream = footsteps[floorType];
			sfxPlayer.play()
	else: 
		animations.current_animation = animations.get_animation_list()[5]
	
	if(waitingToTeleport && !sfxPlayer.playing):
		if(position != personToVisit.global_position + Vector3(0,0,3)):
			mainScn.fadeAndTeleport.emit(personToVisit.global_position + Vector3(0,0,3));
		elif(!isBlackedOut):
			waitingToTeleport = false;
			mainScn.resetDisabledButtons.emit()
			personToVisit.startDialogue();


func die(src:int = 0) -> void:
	if(src == 0):
		sfxPlayer.stream = splat;
	elif(src == 1):
		sfxPlayer.stream = splash;
	sfxPlayer.play()
	PlayerDied.emit();
	isBlackedOut = true;
	mainScn.resetDisabledButtons.emit()


func respawn():
	isBlackedOut = true;


func wakeUp():
	isBlackedOut = false;


func teleportToRespawn():
	print(global_position);
	GameController.close_doors()
	if !specificRespawn:
		var distanceToEachPoint:Array;
		var indexOfShortest:int = 0;
		var test:Vector3;
		for point in respawnPoints:
			distanceToEachPoint.append((global_position-point).length_squared());
		var shortestDist:int = distanceToEachPoint[0]
		for distance in range(len(distanceToEachPoint)):
			if distanceToEachPoint[distance] < shortestDist:
				shortestDist = distanceToEachPoint[distance];
				indexOfShortest = distance;
		global_position = respawnPoints[indexOfShortest];
	else:
		global_position = specificRespawnPoint.global_position


func collect_stamp(ID_num:int):
	sfxPlayer.stream = stampCollected
	sfxPlayer.play();
	if(ID_num == 1):
		GameController.close_doors()
		


func stop_and_face_npc(npc:Node3D):
	isTalking = true;
	var positionToNPC = npc.global_position - global_position
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


func enableFrogJump():
	frogJump = 1;

func visitPersonOfInterest(person:Node3D):
	waitingToTeleport = true;
	personToVisit = person;
