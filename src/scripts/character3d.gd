extends KinematicBody
var vel = Vector3(0, 0, 0)
var speed = 150


func _physics_process(delta):
	if Input.is_action_pressed("move_left"):
		vel.z = -speed
	elif Input.is_action_pressed("move_right"):
		vel.z = speed
	else:
		vel.z = lerp(vel.z, 0, 0.1)
		
	if Input.is_action_pressed("move_up"):
		vel.x = speed
	elif Input.is_action_pressed("move_down"):
		vel.x = -speed
	else:
		vel.x = lerp(vel.x, 0, 0.1)

	move_and_slide(vel)
