extends Node3D

var respawnPoints:Array = [];

func calculatePoints():
	for child in $RespawnPoints/StandardRespawn.get_children():
		respawnPoints.append(child.global_position);
