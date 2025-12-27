extends Node

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	$Resume.hide()
	$"Main Menu".hide()

func _input(event):
	if event.is_action_pressed("pause"):
		Global.pause = !Global.pause
		
		if Global.pause:
			print("PAUSE")
			get_tree().paused = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			$Label.text = "PAUSE"
			$Resume.show()
			$"Main Menu".show()
		else:
			print("RESUME")
			get_tree().paused = false
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			$Label.text = ""
			$Resume.hide()
			$"Main Menu".hide()


func _on_resume_pressed() -> void:
	get_tree().paused = false
	Global.pause = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$Label.text = ""
	$Resume.hide()
	$"Main Menu".hide()
	pass # Replace with function body.

"""
var score = 0
var sponer_health = 1000
var time = {"s": 0, "m": 0}
"""

func _on_main_menu_pressed() -> void:
	Global.score = 0
	Global.sponer_health = 1000
	Global.time = {"s": 0, "m": 0}
	Global.g_bullets_left = 40
	get_tree().paused = false
	Global.pause = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	pass # Replace with function body.
