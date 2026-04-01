extends Node
class_name DangerZone

signal entity_entered(zone_type:String,entity:BaseEntity)
signal entity_exited(zone_type:String,entity:BaseEntity)

var entities=[]
@export var size:Vector3=Vector3(4,4,4)
@export var zone_type:String="unknown"
@export var update_interval:float=3.0
@export var damage:float=7.0
var update_timer:float=0
func _ready() -> void:
	pass

func apply_effect(body:Node3D):
	print("DEBUG: poisoning ",body)
	pass
	
func _process(delta: float) -> void:
	update_timer-=delta
	if update_timer<=0:
		update_timer=update_interval
		if entities.is_empty():
			return
		for e in entities:
			apply_effect(e)


func _on_body_entered(body: Node3D) -> void:
	if body.has_node("StatsControl"):
		if not entities.has(body):
			entities.append(body)
		entity_entered.emit(zone_type,body)
	pass # Replace with function body.


func _on_body_exited(body: Node3D) -> void:
	if body.has_node("StatsControl"):
		if entities.has(body):
			for i in range(entities.size()):
				if entities[i]==body:
					entities.remove_at(i)
	
		entity_exited.emit(zone_type,body)
	pass # Replace with function body.
