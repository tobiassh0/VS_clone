extends Area2D

var level = 1
var hp = 1 # amount of hits it can take
var speed = 100
var damage = 5
var knock_back = 100 # change this later
var attack_size= 1

var target = Vector2.ZERO
var angle = Vector2.ZERO

@onready var player = get_tree().get_first_node_in_group("player")

func _ready():
	angle = global_position.direction_to(target)
	rotation = angle.angle() + deg_to_rad(135) # returns a radian
	match level:
		1:
			hp = 1
			speed = 100
			damage = 5
			knock_back = 100
			attack_size = 1
		2:
			hp += 1
			attack_size *= 2
	# scales the size of the ice spear from being born to full animation
	var tween = create_tween()
	tween.tween_property(self,"scale",Vector2(1,1)*attack_size,1).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()
	
# update position
func _physics_process(delta):
	position += angle*speed*delta

# hits enemy and remove ice spear
func enemy_hit(charge = 1):
	hp -= charge
	if hp <= 0:
		queue_free()

# removes ice spear after time out from creation
func _on_timer_timeout():
	queue_free()
