extends Area2D
export var enemytype = ""
export var face = 1
var bullet = preload("res://scenes/enemy_bullet.tscn")
var speed = 20
var yspeed = 5
var shoot_delay_total = 5
var shoot_delay = shoot_delay_total
var player = null
var process = false
var total_time_y = 0
var amplitude_y = 5

func _ready():
	$sprite.animation = enemytype
	$sprite.set_scale(Vector2(face, 1))

func shoot():
	player = get_tree().get_nodes_in_group("player")[0]
	var w = bullet.instance()
	get_parent().add_child(w)
	w.set_position(position)
	
	w.initialize(player.position)

func _physics_process_walker(delta):
	position.x += speed * face * delta
	
func _physics_process_flyer(delta):	
	position.x += speed * face * delta
	position.y = sin(total_time_y) * amplitude_y
	total_time_y += yspeed * delta
	
	player = get_tree().get_nodes_in_group("player")[0]
	if player.position.x > position.x:
		face = 1
	else: 
		face = -1
	
	shoot_delay -= 1 * delta
	if shoot_delay <= 0:
		shoot_delay = shoot_delay_total
		shoot()

func _physics_process(delta):
	if !process:
		return 
	
	$sprite.set_scale(Vector2(face, 1))
	
	if enemytype == "walker":
		_physics_process_walker(delta)
	elif enemytype == "flyer":
		_physics_process_flyer(delta)

func _on_enemy_area_entered(area):
	if area.is_in_group("walk_stopper"):
		face *= -1
		$sprite.set_scale(Vector2(face, 1))

func _on_visinot_screen_entered():
	process = true

func _on_visinot_screen_exited():
	process = false
