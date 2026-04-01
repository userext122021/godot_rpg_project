extends DangerZone
class_name ToxicPuddle

func apply_effect(body:Node3D):
	if body.has_method("take_damage"):
		body.take_damage(damage)
	print("TOXIC PUDDLE: apply on ",body)
