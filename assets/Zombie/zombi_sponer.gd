extends StaticBody3D

@export var obstacle_scenes: Array[PackedScene] = []
@export var health := 100
@onready var collision_shape_3d_3: CollisionShape3D = $CollisionShape3D2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	while true:
		spawn_obstacle()
		await get_tree().create_timer(30).timeout

func spawn_obstacle() -> void:
	if get_tree().paused == false and Global.sponer_health > 0:
		obstacle_scenes.shuffle()
		var new_obstacal = obstacle_scenes[0].instantiate()

		new_obstacal.player = get_node("/root/mean_world/player")

		add_child(new_obstacal)

func take_damage(a):
	health -= a
	if health <= 0:
		queue_free()
		Global.score += 40
		Global.sponers -= 1
		if Global.sponers == 0:
			get_tree().change_scene_to_file("res://scenes/win_wind.tscn")
	print(health)
