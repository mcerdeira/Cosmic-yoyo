extends Area2D

func _physics_process(delta):
	update()

func _draw():
	var xx
	var yy
	var last_x
	var last_y
	var amount
	var dir
	var argument0 = Vector2(0, 0).x
	var argument1 = Vector2(0, 0).y
	var argument2 = argument0 + rand_range(-100, 100)
	var argument3 = argument1 + rand_range(-100, 100)
	var argument5 = 10
	var argument6 = 6
	var argument7 = 12

	xx = argument0
	yy = argument1
	last_x = argument0
	last_y = argument1
	dir = Vector2(xx, yy).angle_to_point(Vector2(argument2,argument3))

	for i in range(((Vector2(xx, yy).distance_to(Vector2(argument2,argument3))) / argument5) + 5):
		dir = Vector2(xx, yy).angle_to_point(Vector2(argument2,argument3))
		xx += cos(dir) * argument5 * -1
		yy -= sin(dir) * argument5
		
		amount = argument6-rand_range(0, argument7)
		xx += cos(dir - 90) * amount
		yy -= sin(dir - 90) * amount
		draw_line(Vector2(xx,yy),Vector2(last_x,last_y), Color(10, 10, 10), 1)
		last_x = xx
		last_y = yy


func _on_killdisc_item_body_entered(body):
	if body.name == "player":
		body.set_disc()
		queue_free()
