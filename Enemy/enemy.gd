extends CharacterBody2D

# detect player via group
# @onready variable to get value after nodes are loaded
@onready var player = get_tree().get_first_node_in_group("player")

# adds a variable you can edit in the characetr2d node (see right panel)
@export var movement_speed = 20.0
@onready var sprite = $Sprite2D
@onready var anim = $AnimationPlayer
@export var hp = 20.0

func _ready():
	anim.play("walk")
	
func _physics_process(_delta): # underscore delta to show you don't want to use it
	var direction = global_position.direction_to(player.global_position)
	velocity = direction*movement_speed
	move_and_slide()

	if direction.x > 0.1:
		sprite.flip_h = true
	elif direction.x < -0.1:
		sprite.flip_h = false

func _on_hurt_box_hurt(damage):
	hp -= damage
	if hp <= 0:
			queue_free()
