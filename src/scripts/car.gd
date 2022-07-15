extends Area2D
var on = false
var speed = 0
var acel = 100
var player = null
var color = null
var alpha = 0

func start():
	color = get_parent().get_node("CanvasLayer/ColorRect")
	on = true
	$light.visible = true
	$sprite.animation = "on"

func _physics_process(delta):
	if on:
		color.color = Color(0, 0, 0, alpha)
		alpha += 0.3 * delta
		position.x += speed * delta
		player.position.x += speed * delta
		speed += acel * delta
		if alpha >= 1:
			pass

func _on_car_body_entered(body):
	if body.name == "player":
		player = body
		body.enter_car(self)

func _on_car_area_entered(area):
	if area.name == "walk_stopper":
		get_parent().notify_levelend()
