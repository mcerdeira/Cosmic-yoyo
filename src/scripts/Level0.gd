extends Node2D

var color = null
var alpha = 1
var finished = false

func _ready():
	color = get_node("CanvasLayer/ColorRect")
	color.color = Color(0, 0, 0, alpha)
	
func notify_3Dpuzzle():
	get_parent().notify_3Dpuzzle()

func _physics_process(delta):
	if !finished:
		color.color = Color(0, 0, 0, alpha)
		alpha -= 0.5 * delta
		if alpha <= 0:
			finished = true
