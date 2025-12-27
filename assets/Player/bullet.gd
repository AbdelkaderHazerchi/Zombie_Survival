extends Area3D


var speed = 80

func _process(delta: float) -> void:
	
	position += transform.basis * Vector3(0, 0, -speed) * delta
	pass


func _on_body_entered(body: Node3D) -> void:
	print(body.name)
	print(body.get_class())
	if body.is_in_group("enemy"):
		body.take_damage(randi_range(15, 28))
		
		
	if body.is_in_group("zombi_sponer"):
		print("Damage!!!")
		body.take_damage(randi_range(8, 18))
		
	queue_free()  
	pass # Replace with function body.


func _on_timer_timeout() -> void:
	queue_free()
	pass # Replace with function body.
