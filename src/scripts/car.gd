extends Area2D
var on = false
var speed = 0
var acel = 100
var player = null
var color = null
var alpha = 0
var fade = false
var scape = false
var arrive = false
var stoped = false

func _ready():
	var level = get_parent()
	if level.name == "LevelDriving" or level.name == "LevelArrive":
		color = get_parent().get_node("CanvasLayer/ColorRect")
		$light.visible = true
		$sprite.animation = "on"
		$sprite.playing = true

func start():
	color = get_parent().get_node("CanvasLayer/ColorRect")
	on = true
	$light.visible = true
	$sprite.animation = "on"
	$sprite.playing = true
	
func stop():
	$light.visible = false
	$light2.visible = true
	$light3.visible = true
	
	$sprite.animation = "front"
	player.setCameraSpeed(1)
	player.exit_car()
	$collider.disabled = true
	arrive = false
	speed = 0
	stoped = true
	
func arrive():
	arrive = true
	speed = 500
	
func scape():
	scape = true
	fade = true
	speed = 200

func _physics_process(delta):
	if arrive and player:
		position.x += speed * delta
		player.position.x += speed * delta
		
	elif fade:
		position.x += speed * delta
		
		color.color = Color(0, 0, 0, alpha)
		alpha += 0.3 * delta
		if alpha >= 1:
			get_parent().notify_levelend()
	elif on:
		position.x += speed * delta
		player.position.x += speed * delta
		player.setCameraSpeed(5)
		speed += acel * delta

func _on_car_body_entered(body):
	if !stoped:
		var level = get_parent()
		if body.name == "player":
			player = body
			if level.name == "LevelArrive":
				body.setCameraSpeed(5)
				body.car_entered()
			else:
				body.enter_car(self)

func _on_car_area_entered(area):
	if !stoped:
		var level = get_parent()
		if level.name == "LevelArrive":
			if area.name == "walk_stopper":
				stop()
				player.visible = true
		else:
			if area.name == "walk_stopper":
				player.setCamera(false)
				fade = true
		
