extends CharacterBody3D

@export var speed = 8
@export var gravity = -10
@export var chase_distance := 15.0

# نصف طول المربع حول الزومبي للحركة العشوائية
@export var random_range := 30.0  # يتحرك الزومبي داخل مربع 20x20 حول نفسه

@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var player := get_tree().get_first_node_in_group("player")

@onready var anim = $holder/AnimationPlayer
@onready var holder = $holder
@onready var footsteps: AudioStreamPlayer3D = $AudioStreamPlayer3D

@export var health := 100

var target_position: Vector3  # هدف الحركة العشوائية

func _ready() -> void:
	randomize()
	anim.play("mixamo_com")
	set_random_target()

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta

	if player == null:
		return

	var distance_to_player = global_position.distance_to(player.global_position)

	if distance_to_player <= chase_distance:
		# اللاعب قريب → مطاردة اللاعب
		chase_distance = 40.0
		navigation_agent_3d.target_position = player.global_position
		move_toward_target(delta)
	else:
		# اللاعب بعيد → حركة عشوائية حول الزومبي
		var distance_to_target = global_position.distance_to(target_position)
		if distance_to_target < 0.5 or navigation_agent_3d.is_navigation_finished():
			set_random_target()
		move_toward_target(delta)

func move_toward_target(delta: float) -> void:
	var next_pos = navigation_agent_3d.get_next_path_position()
	var dir = (next_pos - global_position).normalized()

	if dir.length() > 0.001:
		look_at(global_position + dir, Vector3.UP)

	velocity.x = dir.x * speed
	velocity.z = dir.z * speed

	if dir.length() > 0.1:
		if not footsteps.playing:
			footsteps.play()
	else:
		if footsteps.playing:
			footsteps.stop()

	move_and_slide()

# اختيار نقطة عشوائية حول الزومبي نفسه
func set_random_target() -> void:
	var x = global_position.x + randf_range(-random_range, random_range)
	var y = global_position.y
	var z = global_position.z + randf_range(-random_range, random_range)
	target_position = Vector3(x, y, z)
	navigation_agent_3d.target_position = target_position

func take_damage(a):
	health -= a
	if health <= 0:
		queue_free()
		Global.score += 1
	print(health)

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		body.damage(randi_range(8, 12))
