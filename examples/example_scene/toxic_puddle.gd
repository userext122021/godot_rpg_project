extends MeshInstance3D

@export var damage:float=7.0
var entities=[]

func _on_danger_zone_entity_entered(zone_type: String, entity: BaseEntity) -> void:
	entities.push_back(entity)
	pass # Replace with function body.


func _on_danger_zone_entity_exited(zone_type: String, entity: BaseEntity) -> void:
	if entities.has(entity):
		for i in range(entities.size()):
			if entities[i]==entity:
				entities.remove_at(i)
				return
	pass # Replace with function body.


func _on_timer_timeout() -> void:
	for e in entities:
		if e.has_method("take_damage"):
			e.take_damage(damage)
	pass # Replace with function body.
