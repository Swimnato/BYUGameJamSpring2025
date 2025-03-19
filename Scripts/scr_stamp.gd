extends Node3D

@export var ID_num = 0;

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		body.collect_stamp(ID_num)
		queue_free();
		#for child in get_children():
			#remove_child(child)
			#child.queue_free()
