extends Node3D

@onready var player: CharacterBody3D = $"../Player"
@export var pos = Vector3(0, 0, 0);


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		body.position = pos;
