extends AnimationPlayer


func _on_trigger_cat_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		play("Cat Out of Water");
