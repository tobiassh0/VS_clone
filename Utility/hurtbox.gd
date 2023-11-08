extends Area2D

@export_enum("Cooldown","HitOnce","DisableHitBox") var HurtBoxType = 0
@onready var collision = $CollisionShape2D
@onready var disableTimer = $DisableTimer

var hit_once_array=[]
signal hurt(damage, angle, knockback) # signal from hurt

func _on_area_entered(area):
	if area.is_in_group("attack"):
		if not area.get("damage") == null:
			match HurtBoxType:
				0: # Cooldown
					collision.call_deferred("set","disabled",true) # disables collision shape
					#collision.disabled = true # won't work in real time
					disableTimer.start()
				1: # HitOnce
					if hit_once_array.has(area) == false: # capture any time enemy is hit
						hit_once_array.append(area)
						if area.has_signal("remove_from_array"): # create signal to remake the array
							if not area.is_connected("remove_from_array",Callable(self,"remove_from_list")):
								area.connect("remove_from_array",Callable(self,"remove_from_list"))
								# signal is connected
					else:
						return
				2: # DisableHitBox
					if area.has_method("tempDisable"):
						area.tempDisable()
			var damage = area.damage
			var angle = Vector2.ZERO
			var knockback = 1
			if not area.get("angle") == null:
				angle = area.angle # angle from ice spear
			if not area.get("knockback_amount") == null:
				knockback = area.knockback_amount
			# emit custom signal
			emit_signal("hurt",damage,angle,knockback)
			if area.has_method("enemy_hit"):
				area.enemy_hit(1)
	
func remove_from_list(object):
	if hit_once_array.has(object):
		hit_once_array.erase(object)

func _on_disable_timer_timeout():
	collision.call_deferred("set","disabled",false) # disables collision shape
