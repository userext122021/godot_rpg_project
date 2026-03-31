extends Node
class_name DangerZone

signal entity_entered(zone_type:String,entity:BaseEntity)
signal entity_exited(zone_type:String,entity:BaseEntity)


@export var size:Vector3=Vector3(4,4,4)
@export var zone_type:String="unknown"

func _ready() -> void:
	update()

func update():
	var c:CylinderShape3D=$CollisionShape3D.shape
	c.radius=max(size.x,size.z)


func _on_body_entered(body: Node3D) -> void:
	if body.has_node("StatsControl"):
		entity_entered.emit(zone_type,body)
	pass # Replace with function body.


func _on_body_exited(body: Node3D) -> void:
	if body.has_node("StatsControl"):
		entity_exited.emit(zone_type,body)
	pass # Replace with function body.
