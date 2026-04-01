extends DangerZone
class_name ToxicPuddle
var duration:float=5.0
var tick_time:float=0.5
var damage:float=3


func _ready() -> void:
	zone_type="poison"
func apply_effect(body:Node3D):
	if body.has_method("add_effect"):
		body.add_effect(zone_type,duration,tick_time,damage)
		print("TOXIC PUDDLE: apply on ",body)
