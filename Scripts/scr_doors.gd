extends Node3D
@onready var collision_shape_3d: CollisionShape3D = $DoorHitbox/CollisionShape3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer3
@onready var animation_player_2: AnimationPlayer = $AnimationPlayer2
@export var automatic_door:bool = false;

func _ready() -> void:
	if(!automatic_door):
		GameController.doors.append(self);
		$"Auto Door Open".queue_free();
	else:
		collision_shape_3d.disabled = true;
		

#func _process(delta):
	#print(collision_shape_3d.disabled);

func close_doors() -> void:
	collision_shape_3d.disabled = false;
	animation_player.play_backwards("door_001Action");
	animation_player_2.play_backwards("doorAction");

func open_doors() -> void:
	collision_shape_3d.disabled = true;
	animation_player.play("door_001Action")
	animation_player_2.play("doorAction")


func _on_auto_door_open_body_entered(body: Node3D) -> void:
	if(automatic_door && body.name.to_lower().contains("player")):
		open_doors()


func _on_auto_door_open_body_exited(body: Node3D) -> void:
	if(automatic_door && body.name.to_lower().contains("player")):
		close_doors();
