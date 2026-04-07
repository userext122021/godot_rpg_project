extends Node
class_name BaseAI


var body:BaseAIEntity
var target:Vector3
var is_move_to_target:bool=false
var minimal_distance:float=2.0
var is_target_reached:bool=false
var is_active:bool=true

	
func update(delta:float):
	pass

func on_entity_entered(e:BaseEntity):
	pass		
func on_entity_exited(e:BaseEntity):
	pass
func init_ai():
	body.entity_entered.connect(on_entity_entered)
	body.entity_exited.connect(on_entity_exited)
