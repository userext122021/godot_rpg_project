extends BaseAnimatedEnemy
class_name TestEnemy

func _ready() -> void:
	super._ready()
	ai.minimal_distance=2.0
	pass
	
	
func _process(delta: float) -> void:
	if global_position.y<-10:
		die()
