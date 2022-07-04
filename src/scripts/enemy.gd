extends Area2D
export var enemytype = ""
var face = 1
var speed = 20

func _ready():
	$sprite.animation = enemytype

func _physics_process_walker(delta):
	position.x += speed * face * delta
	

func _physics_process(delta):
	if enemytype == "walker":
		_physics_process_walker(delta)


func _on_enemy_area_entered(area):
	if area.is_in_group("walk_stopper"):
		face *= -1
		$sprite.set_scale(Vector2(face, 1))
