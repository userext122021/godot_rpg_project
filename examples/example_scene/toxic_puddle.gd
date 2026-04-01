extends DangerZone
class_name ToxicPuddle
var effect_name:String="poison"
var duration:float=5.0
var tick_time:float=1.0
var damage:float=3

func apply_effect(body:Node3D):
	if body.has_method("add_effect"):
		body.add_effect(effect_name,duration,tick_time,damage)
		print("TOXIC PUDDLE: apply on ",body)
