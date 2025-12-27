extends CharacterBody3D


@export var SPEED: float  = 7.0
@export var JUMP_VELOCITY = 4.5
@export var gravity = -9.8
@export var SENSITIVITY = 0.004
var damage_timer := Timer.new()
@onready var head: Node3D = $head
@onready var camera: Camera3D = $head/Camera3D

@onready var gun_raycast: Node3D = $head/Camera3D/gun/RayCast3D
@onready var gun_animation: AnimationPlayer = $head/Camera3D/gun/AnimationPlayer
var bullets_left = 30
var bullet = preload("res://assets/Player/bullet.tscn")
var health = 100


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	add_child(damage_timer)
	damage_timer.one_shot = true
	damage_timer.connect("timeout", Callable(self, "_stop_damage_sound"))
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))
	
	pass

func _physics_process(delta: float) -> void:
	# Add the gravity.
	SPEED  = 7.0
	JUMP_VELOCITY = 4.5
	gravity = -9.8
	SENSITIVITY = 0.002

	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump. full_speed
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_pressed("shoot") and bullets_left > 0:
		if !gun_animation.is_playing():
			gun_animation.play("shoot")
			$shooting.play()
			shoot()
	
	if Input.is_action_pressed("full_speed"):
		SPEED = 12.0
		$head/Camera3D/AnimationPlayer.speed_scale = 3.3
		$walking.pitch_scale = 2.0
	else:
		$head/Camera3D/AnimationPlayer.speed_scale = 1.0
		$walking.pitch_scale = 1.0
	
	if Global.player_health <= 0:
		get_tree().change_scene_to_file("res://scenes/lose_wind.tscn")
	
	$head/Camera3D/Label.text = str(Global.g_bullets_left)
	if bullets_left < 10:
		$head/Camera3D/Label5.text = "0" + str(bullets_left) + "/"
	else:
		$head/Camera3D/Label5.text = str(bullets_left) + "/"
	$head/Camera3D/Label2.text = str(Global.player_health) + "%"
	$head/Camera3D/Label3.text = "score:" + str(Global.score)
	if Global.time["s"] < 10:
		$head/Camera3D/time.text = str(Global.time["m"]) + ":0" + str(Global.time["s"])
	else:
		$head/Camera3D/time.text = str(Global.time["m"]) + ":" + str(Global.time["s"])
	if Input.is_action_just_pressed("reload") and Global.g_bullets_left > 0:
		gun_animation.play("reload")
		Global.g_bullets_left += bullets_left
		bullets_left = 0
		if Global.g_bullets_left > 30:
			Global.g_bullets_left -= 30
			bullets_left = 30
		else:
			bullets_left += Global.g_bullets_left
			Global.g_bullets_left = 0
		$reload.play()
		pass



	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		if !$head/Camera3D/AnimationPlayer.is_playing():
			$head/Camera3D/AnimationPlayer.play("walk")
			$walking.play()
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		if $head/Camera3D/AnimationPlayer.is_playing():
			$head/Camera3D/AnimationPlayer.stop()
			$head/Camera3D/AnimationPlayer.seek(0)
			$walking.stop()
		

	move_and_slide()

func damage(dm):
	Global.player_health -= dm
	play_damage_part(0.5, 1.0)
	pass

func play_damage_part(start_time: float, duration: float) -> void:
	$damage.seek(start_time)
	$damage.play()
	damage_timer.start(duration)

func _stop_damage_sound():
	$damage.stop()

func shoot():
	bullets_left -= 1
	var bullet_instance = bullet.instantiate()
	bullet_instance.position = gun_raycast.global_position
	bullet_instance.transform.basis = gun_raycast.global_transform.basis
	get_parent().add_child(bullet_instance)
	pass


func _on_timer_timeout() -> void:
	if Global.time["s"] <= 59:
		Global.time["s"] += 1
	else:
		Global.time["s"] = 0
		Global.time["m"] += 1
	pass # Replace with function body.
