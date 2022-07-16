extends Area2D
var on = false
var speed = 0
var acel = 100
var player = null
var color = null
var alpha = 0
var fade = false
var scape = false

func _ready():
	var level = get_parent()
	if level.name == "LevelDriving":
		color = get_parent().get_node("CanvasLayer/ColorRect")
		$light.visible = true
		$sprite.animation = "on"

func start():
	color = get_parent().get_node("CanvasLayer/ColorRect")
	on = true
	$light.visible = true
	$sprite.animation = "on"
	
func scape():
	scape = true
	fade = true
	speed = 200

func _physics_process(delta):
	if fade:
		if scape:
			position.x += speed * delta
		
		color.color = Color(0, 0, 0, alpha)
		alpha += 0.3 * delta
		if alpha >= 1:
			get_parent().notify_levelend()
	elif on:
		position.x += speed * delta
		player.position.x += speed * delta
		speed += acel * delta

func _on_car_body_entered(body):
	if body.name == "player":
		player = body
		body.enter_car(self)

func _on_car_area_entered(area):
	if area.name == "walk_stopper":
		player.setCamera(false)
		fade = true
		
