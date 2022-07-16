extends Node2D

var color = null
var alpha = 1
var finished = false

func _ready():
	color = get_node("CanvasLayer/ColorRect")
	color.color = Color(0, 0, 0, alpha)

func _physics_process(delta):
	if !finished:
		color.color = Color(0, 0, 0, alpha)
		alpha -= 1 * delta
		if alpha <= 0:
			finished = true
			if $AnimationPlayer:
				$AnimationPlayer.play("labels")

func notify_levelend():
	get_parent().notify_levelend()

func _on_AnimationPlayer_animation_finished(anim_name):
	get_node("car").scape()
