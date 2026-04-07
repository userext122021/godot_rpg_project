extends BaseAnimatedEnemy


func _process(delta: float) -> void:
	if global_position.y<-10:
		die()
