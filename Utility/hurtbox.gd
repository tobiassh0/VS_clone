extends Area2D

@export_enum("Cooldown","HitOnce","DisableHitBox") var HurtBoxType = 0
@onready var collision = $CollisionShape2D
@onready var disableTimer = $DisableTimer

signal hurt(damage)


func _on_area_entered(area):
	if area.is_in_group("attack"):
		if not area.get("damage") == null:
			match HurtBoxType:
				0: # Cooldown
					collision.call_deferred("set","disabled",true) # disables collision shape
					#collision.disabled = true # won't work in real time
					disableTimer.start()
				1: # HitOnce
					pass
				2: # DisableHitBox
					if area.has_method("tempDisable"):
						area.tempDisable()
			var damage = area.damage
			# emit custom signal
			emit_signal("hurt",damage)
			if area.has_method("enemy_hit"):
				area.enemy_hit(1)
			
func _on_disable_timer_timeout():
	collision.call_deferred("set","disabled",false) # disables collision shape
