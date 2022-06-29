extends Area2D
var speed = 6
var total_time_x = 0
var amplitude_x = 10

var total_time_y = 0
var amplitude_y = 0
var base_x = 0
var base_y = -15
var player = null
var prev_x = 0

func _ready():
#	Engine.time_scale = 0.09
	prev_x = position.x
	player = get_parent()
	
func punched():
	if player.face == 1:
		if prev_x > position.x:
			position.x = 14
			total_time_x = 206
	else:
		if prev_x < position.x:
			position.x = -17
			total_time_x = 59

func punched_up():
	pass

func _physics_process(delta):
	prev_x = position.x
	position.x = (base_x * player.face) + (cos(total_time_x) * amplitude_x)

	total_time_x += speed * delta

	position.y = base_y + sin(total_time_y) * amplitude_y
	total_time_y += speed * delta

	$sprite.rotation_degrees += 1000 * delta
