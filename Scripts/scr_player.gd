extends CharacterBody3D

@onready var animations: AnimationPlayer = $Pivot/model/AnimationPlayer

@export var speed = 6
@export var fall_acceleration = 75
@export var jump_force = 40
var target_velocity = Vector3.ZERO

func _physics_process(delta):
	var direction = Vector3.ZERO
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
	
func handleAnimations(target_velocity: Vector3) -> void: 
	if target_velocity.x || target_velocity.z != 0:
		animations.current_animation = animations.get_animation_list()[1]
	else: 
		animations.current_animation = animations.get_animation_list()[0]

func die() -> void:
	print("TODO: die");
