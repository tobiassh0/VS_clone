extends CharacterBody2D

@export var movement_speed = 80.0
@onready var sprite = $Sprite2D
@onready var walkTimer = get_node("%walkTimer")

var posplayer = position
var hp = 80.0
# attack #
var iceSpear = preload("res://Player/attack.tscn")
# attack nodes # 
@onready var iceSpearTimer = get_node("Attack/IceSpearTimer")
@onready var iceSpearAttackTimer = get_node("Attack/IceSpearTimer/IceSpearAttackTimer")
# Ice spear #
var icespear_ammo = 0 
var icespear_baseammo = 1
var icespear_attackspeed = 1.5
var icespear_level = 1

# enemy related #
var enemy_close = []

func _ready():
	attack()

# godot defined function
func _physics_process(_delta): # every single frame
#	delta = 1/60 # of a second
	movement()

func movement():
	# detect which keys are pressed
	var x_mov = Input.get_action_strength("right") - Input.get_action_strength("left")
	# down is +ve (see original screen view) 
	var y_mov = Input.get_action_strength("down") - Input.get_action_strength("up")
	# set the vector to move in the direction of movement keys (x,y)
	var mov = Vector2(x_mov,y_mov)
	# determine whether facing left or right
	if mov.x > 0: # facing right
		sprite.flip_h = true
	elif mov.x < 0: # facing left
		sprite.flip_h = false
	if mov != Vector2.ZERO:
		if walkTimer.is_stopped():
			if sprite.frame >= sprite.hframes - 1:
				sprite.frame=0
			else:
				sprite.frame+=1
			walkTimer.start()
	# determine velocity by normalised movement (in time)	
	velocity = mov.normalized()*movement_speed
	move_and_slide() # godot function	

func _on_hurt_box_hurt(damage):
	hp -= damage
	print(hp)

func attack():
	if icespear_level > 0:
		iceSpearTimer.wait_time = icespear_attackspeed
		if iceSpearTimer.is_stopped():
			iceSpearTimer.start()

func _on_ice_spear_timer_timeout():
	# loading ammo
	icespear_ammo += icespear_baseammo
	iceSpearAttackTimer.start()

func _on_ice_spear_attack_timer_timeout():
	# shooting
	if icespear_ammo > 0:
		var icespear_attack = iceSpear.instantiate()
		icespear_attack.position = position
		icespear_attack.target = get_random_target()
		icespear_attack.level = icespear_level
		add_child(icespear_attack)
		icespear_ammo -= 1
		if icespear_ammo > 0:
			iceSpearAttackTimer.start()
		else:
			iceSpearAttackTimer.stop()

func get_random_target():
	if enemy_close.size() > 1:
		var enemy_close_dist = []
		for i in enemy_close: # TODO : mostly works
			enemy_close_dist.append(sqrt(pow(posplayer.x-i.global_position.x,2) + pow(posplayer.y-i.global_position.y,2)))
		var index = enemy_close_dist.find(enemy_close_dist.min(),0)
		return enemy_close[index].global_position
	elif enemy_close.size() == 1:
		return enemy_close.pick_random().global_position
	else:
		return Vector2.UP # shoot up if nothing on the screen

func _on_enemy_detection_area_body_entered(body):
	if not enemy_close.has(body):
		enemy_close.append(body)

func _on_enemy_detection_area_body_exited(body):
	if enemy_close.has(body):
		enemy_close.erase(body)
