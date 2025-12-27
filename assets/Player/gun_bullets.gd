extends Area3D


func _on_body_entered(body: Node3D) -> void:
	print(body.name)
	print(body.get_class())
	if body.is_in_group("player"):
		Global.g_bullets_left += 30
		
	$AudioStreamPlayer3D.play()
	await $AudioStreamPlayer3D.finished
	queue_free()  
	pass # Replace with function body.
