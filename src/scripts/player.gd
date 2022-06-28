extends KinematicBody2D

export var gravity = 7
var vspeed = Vector2.ZERO
var face = 1
export var player_speed = 150
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

func punch_collider_disabled(val):
	$puncho/collider.disabled = val
	$uppuncho/collider.disabled = val
	
func CameraShake(delta):
	$Camera2D.shake(delta, 0.1)
	
func CameraShakeValue(delta, value):
	$Camera2D.shake(delta, value)

func CameraDefault():
	$Camera2D.default()

func _ready():
	punch_collider_disabled(true)
	
	killingdisc = get_node("killingdisc")
	
func punch():
	animationdelay = 0.5
	punching = 0.1
	if Input.is_action_pressed("move_up"):
		var add = 0
		if killingdisc.amplitude_x != 0:
			add = killingdisc.amplitude_x
			killingdisc.amplitude_x = 0
		killingdisc.amplitude_y += 60 + add
		killingdisc.amplitude_y = min(killingdisc.amplitude_y, max_amplitude)
	else:
		var add = 0
		if killingdisc.amplitude_y != 0:
			add = killingdisc.amplitude_y
			killingdisc.amplitude_y = 0
		killingdisc.amplitude_x += 60 + add
		killingdisc.amplitude_x = min(killingdisc.amplitude_x, max_amplitude)
		
func _physics_process(delta):
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
	
	if (!attacking or ! is_on_floor()) and Input.is_action_pressed("move_left"):
		position.x -= player_speed * delta
		$puncho.set_scale(Vector2(-1, 1))
		$uppuncho.set_scale(Vector2(-1, 1))
		$player_sprite.set_scale(Vector2(-1, 1))
		face = -1
		moving = true
	elif (!attacking or ! is_on_floor()) and Input.is_action_pressed("move_right"):
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
	
	if punching <= 0:
		if moving:
			killingdisc.amplitude_x = lerp(killingdisc.amplitude_x, 50, 0.1)
		else:
			killingdisc.amplitude_x = lerp(killingdisc.amplitude_x, 20, 0.01)

		if killingdisc.amplitude_y != 0:
			killingdisc.amplitude_y = lerp(killingdisc.amplitude_y, 0, 0.01)

func _draw():
	pass
	#draw_line(Vector2(12 * face, -5), fist.position,  Color(255, 255, 255), 1)

func _on_puncho_area_entered(area):
	if area.name == "killingdisc":
		punch()
