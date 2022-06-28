extends Area2D
var speed = 6
var total_time_x = 0
var amplitude_x = 10

var total_time_y = 0
var amplitude_y = 0
var base_x = 0
var player = null

func _ready():
	player = get_parent()

func _physics_process(delta):
	position.x = (base_x * player.face) + (cos(total_time_x) * amplitude_x)
	total_time_x += speed * delta
	
	position.y = cos(total_time_y) * amplitude_y
	total_time_y += speed * delta
	
	$sprite.rotation_degrees += 1000 * delta
