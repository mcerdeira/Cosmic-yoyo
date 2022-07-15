extends KinematicBody2D

export var gravity = 7
var vspeed = Vector2.ZERO
var face = 1
export var player_speed = 100
export var player_jump_speed = 250
var max_amplitude = 200
var jumping = false
var attacking = false
var attack_ttl = 0
var fake_attack = false
var fake_attack_ttl = 0
var killingdisc = null
var punching = 0
var animationdelay = 0
var saturate = 0
var saturate_dir = 1
var has_disc = false
var enter_car_ttl = 0
var enter_car_flag = false
var car = null

func punch_collider_disabled(val):
	$puncho/collider.disabled = val
	$uppuncho/collider.disabled = val
	
func CameraShake(delta):
	$Camera2D.shake(delta, 0.1)
	
func CameraShakeValue(delta, value):
	$Camera2D.shake(delta, value)

func CameraDefault():
	$Camera2D.default()
	
func hurt():
	pass
	
func enter_car(_car):
	car = _car
	$player_sprite.animation = "default"
	$player_sprite.playing = false 
	enter_car_flag = true
	enter_car_ttl = 0.6

func _ready():
	add_to_group("player")
	punch_collider_disabled(true)
	killingdisc = get_node("killingdisc")
	if !has_disc:
		killingdisc.set_physics_process(false)
		killingdisc.visible = false
	
func set_disc():
	has_disc = true
	killingdisc.set_physics_process(true)
	killingdisc.visible = true
	
func punch(kdisc):
	animationdelay = 0.5
	punching = 0.1
	if Input.is_action_pressed("move_up"):
		kdisc.punched_up()
		$player_sprite.animation = "attacking_up"
		var add = 0
		if killingdisc.amplitude_x != 0:
			add = killingdisc.amplitude_x
			killingdisc.amplitude_x = 0
		killingdisc.amplitude_y += 60 + add
		killingdisc.amplitude_y = min(killingdisc.amplitude_y, max_amplitude)
	else:
		kdisc.punched()
		$player_sprite.animation = "attacking"
		var add = 0
		if killingdisc.amplitude_y != 0:
			add = killingdisc.amplitude_y
			killingdisc.amplitude_y = 0
		killingdisc.amplitude_x += 60 + add
		killingdisc.amplitude_x = min(killingdisc.amplitude_x, max_amplitude)
		
func _physics_process(delta):
	if enter_car_flag:
		enter_car_ttl -= 1 * delta
		if visible and enter_car_ttl <= 0:
			visible = false
			car.start()
			
		return 0
	
	var moving = false
	vspeed.y += gravity
	
	if animationdelay > 0:
		animationdelay -= 1 * delta
		if animationdelay <= 0:
			animationdelay = 0
	
	if punching > 0:
		punching -= 1 * delta
		CameraShakeValue(delta, 0.05)
		if punching <= 0:
			punching = 0
			CameraDefault()
	
	if attack_ttl > 0:
		attack_ttl -= 1 * delta
		if attack_ttl <=0:
			punch_collider_disabled(true)
			attacking = false
			attack_ttl = 0
	
	if !attacking and Input.is_action_just_pressed("attack") or fake_attack:
		punch_collider_disabled(false)
		fake_attack = false
		attacking = true
		attack_ttl = 0.1
	
	if !attacking and Input.is_action_pressed("attack"):
		fake_attack_ttl += 1 * delta
		if fake_attack_ttl >= 0.2:
			fake_attack = true
			fake_attack_ttl = 0
	
	if (!attacking or !is_on_floor()) and Input.is_action_pressed("move_left"):
		if animationdelay > 0 and is_on_floor():
			pass 
		else:
			position.x -= player_speed * delta
			$puncho.set_scale(Vector2(-1, 1))
			$uppuncho.set_scale(Vector2(-1, 1))
			$player_sprite.set_scale(Vector2(-1, 1))
			face = -1
			moving = true
	elif (!attacking or ! is_on_floor()) and Input.is_action_pressed("move_right"):
		if animationdelay > 0 and is_on_floor():
			pass 
		else:
			position.x += player_speed * delta
			$puncho.set_scale(Vector2(1, 1))
			$uppuncho.set_scale(Vector2(1, 1))
			$player_sprite.set_scale(Vector2(1, 1))
			face = 1
			moving = true
		
	if jumping and is_on_floor():
		jumping = false
	
	if is_on_floor() and Input.is_action_pressed("jump"):
		jumping = true
		vspeed.y = -player_jump_speed
	
	if animationdelay <= 0:
		if jumping and !attacking:
			$player_sprite.animation = "jumping"
		elif moving:
			$player_sprite.animation = "walking"
		elif attacking:
			if Input.is_action_pressed("move_up"):
				$player_sprite.animation = "attacking_up"
			else:
				$player_sprite.animation = "attacking"
		else:
			$player_sprite.animation = "default"
				
		$player_sprite.playing = moving
	
	vspeed = move_and_slide(vspeed, Vector2.UP)
	
	saturate = killingdisc.amplitude_x + killingdisc.amplitude_y
	saturate = saturate / 10
	
	
	if punching <= 0:
		if moving:
			killingdisc.amplitude_x = lerp(killingdisc.amplitude_x, 50, 0.1)
		else:
			killingdisc.amplitude_x = lerp(killingdisc.amplitude_x, 20, 0.01)

		if killingdisc.amplitude_y != 0:
			killingdisc.amplitude_y = lerp(killingdisc.amplitude_y, 0, 0.01)
			
	update()

func _draw():
	if has_disc:
		var xx
		var yy
		var last_x
		var last_y
		var amount
		var dir
		var argument0 = Vector2(0, 0).x
		var argument1 = Vector2(0, 0).y + killingdisc.base_y
		var argument2 = killingdisc.position.x
		var argument3 = killingdisc.position.y
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
			draw_line(Vector2(xx,yy),Vector2(last_x,last_y), Color(saturate, saturate, saturate), 1)
			last_x = xx
			last_y = yy
		
func _on_puncho_area_entered(area):
	if has_disc:
		if punching <= 0:
			if area.name == "killingdisc":
				punch(area)
