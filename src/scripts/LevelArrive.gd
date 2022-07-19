extends Node2D

var color = null
var alpha = 1
var finished = false
var levelended = false

func _ready():
	color = get_node("CanvasLayer/ColorRect")
	color.color = Color(0, 0, 0, alpha)
	get_node("car").arrive()
	
func _physics_process(delta):
	if levelended:
		color.color = Color(0, 0, 0, alpha)
		alpha += 0.3 * delta
		if alpha >= 1:
			notify_levelend()
		
	if !finished:
		color.color = Color(0, 0, 0, alpha)
		alpha -= 1 * delta
		if alpha <= 0:
			finished = true

func notify_levelend():
	get_parent().notify_levelend()

func _on_level_switch_body_entered(body):
	if body.name == "player":
		levelended = true
