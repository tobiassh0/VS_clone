extends Area2D

@export var damage = 1.0
@onready var collision = $CollisionShape2D
@onready var disableTimer = $DisableHitBoxTimer

func tempDisable():
	collision.call_deferred("set","disabled",true)
	disableTimer.start()
	
# linked from node Timer
func _on_disable_hit_box_timer_timeout():
	collision.call_deferred("set","disabled",false) # disables collision shape


