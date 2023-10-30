extends CharacterBody2D

@export var movement_speed = 80.0
@onready var sprite = $Sprite2D
@onready var walkTimer = get_node("%walkTimer")
var hp = 80.0

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
