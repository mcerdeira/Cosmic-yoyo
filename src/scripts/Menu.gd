extends Node2D
var c = 2.5
var lerp_dir = -1
var done = false
var ttl = 0.3

func _ready():
	pass

func _process(delta):
	if !done:
		ttl -= 1 * delta
		if ttl <= 0:
			$normal.speed_scale = 2.5
			$glower.speed_scale = $normal.speed_scale
			$normal.playing = true
			$glower.playing = true
		
	else:
		$normal.modulate = Color(c, c, c)
		c += (0.3 * lerp_dir)  * delta
		if lerp_dir == -1:
			if c <= 1.7:
				lerp_dir = 1
		else:
			if c >= 2:
				lerp_dir = -1

func _on_glower_animation_finished():
	$normal.playing = false
	$normal.modulate = Color(c, c, c)
	done = true
	$normal.frame = 10
	$glower.playing = false
	$glower.visible = false
