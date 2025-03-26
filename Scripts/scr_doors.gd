extends Node3D
@onready var collision_shape_3d: CollisionShape3D = $StaticBody3D/CollisionShape3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_player_2: AnimationPlayer = $AnimationPlayer2

func _ready() -> void:
	GameController.doors.append(self);

func close_doors() -> void:
	collision_shape_3d.disabled = false;

func open_doors() -> void:
	collision_shape_3d.disabled = true;
	animation_player.play("door_001Action")
	animation_player_2.play("doorAction")
	
