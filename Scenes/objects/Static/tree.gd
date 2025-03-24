extends Node3D

@export var treeMesh = 0;

@onready var trees:Array = [$env_tree1,$env_tree2,$env_tree3];

func _ready():
	for i in range(len(trees)):
		trees[i].visible = i == treeMesh;
		if(trees[i].visible):
			for child in trees[i].get_children():
				if(child.name.to_lower().contains("collision")):
					child.set_use_collision(true);
