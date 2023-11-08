extends CharacterBody2D

# detect player via group
# @onready variable to get value after nodes are loaded
@onready var player = get_tree().get_first_node_in_group("player")

# adds a variable you can edit in the characetr2d node (see right panel)
@export var movement_speed = 20.0
@onready var sprite = $Sprite2D
@onready var anim = $AnimationPlayer
@onready var snd_hit = $snd_hit

@export var hp = 10.0
@export var knockback_recovery = 3.5

var knockback = Vector2.ZERO
var death_anim = preload("res://Enemy/explosion.tscn")

signal remove_from_array(object) # signals whether has been hit once

func _ready():
	anim.play("walk")
	
func _physics_process(_delta): # underscore delta to show you don't want to use it
	knockback = knockback.move_toward(Vector2.ZERO, knockback_recovery)
	var direction = global_position.direction_to(player.global_position)
	velocity = direction*movement_speed
	velocity += knockback
	move_and_slide()

	if direction.x > 0.1:
		sprite.flip_h = true
	elif direction.x < -0.1:
		sprite.flip_h = false

func death():
	emit_signal("remove_from_array",self)
	var enemy_death = death_anim.instantiate()
	enemy_death.scale = sprite.scale
	enemy_death.global_position = global_position
	get_parent().call_deferred("add_child",enemy_death) # spawns enemy death overtop of enemy
	queue_free()
	
func _on_hurt_box_hurt(damage,angle,knockback_amount):
	hp -= damage
	if hp <= 0:
		death()
	else:
		knockback = angle*knockback_amount
		snd_hit.play()
