extends Node3D

var respawnPoints:Array = [];


func _ready():
	for child in $SubScenes.get_children():
		child.calculatePoints();
		for point in child.respawnPoints:
			#respawnPoints.append(child.position + (point * child.scale))
			respawnPoints.append(child.to_global(point))
