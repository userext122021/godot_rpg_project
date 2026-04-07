extends BaseEnemy
class_name BaseAnimatedEnemy



func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	update_animation()
