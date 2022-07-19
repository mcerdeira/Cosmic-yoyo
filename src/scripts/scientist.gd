extends KinematicBody2D
export var runaway = false
var speed = 0
var speeds = [150, 120, 100, 90]

func _ready():
	speed = speeds[rand_range(0, 3)]

func _physics_process(delta):
	if runaway:
		$sprite.set_scale(Vector2(-1, 1))
		$sprite.animation = "walking"
		$sprite.playing = true
		position.x -= speed * delta
