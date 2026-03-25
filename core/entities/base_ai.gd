extends Node
class_name BaseAI

var body:BaseAIEntity
var entity_body:Node3D

func _ready() -> void:
	body=get_parent()
	body.entity_entered.connect(_on_entity_entered)
	body.entity_exited.connect(_on_entity_exited)
	body.target_reached.connect(_on_target_reached)

func _on_entity_entered(e_body:Node3D):
	entity_body=e_body
	pass
	
func _on_entity_exited(e_body:Node3D):
	entity_body=null
	pass

func _on_target_reached():
	pass

func _update(delta):
	pass
