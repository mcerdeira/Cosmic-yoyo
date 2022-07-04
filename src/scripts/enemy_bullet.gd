extends Area2D
var speed = 100

func initialize(rot):
	look_at(rot)

func _physics_process(delta):
	$sprite.rotation += 10 * delta
	
	position += transform.x * speed * delta

func _on_visinot_screen_exited():
	queue_free()

func _on_enemy_bullet_area_entered(area):
	if area.name == "player":
		area.hurt()
		queue_free()
