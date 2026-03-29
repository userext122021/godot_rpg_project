extends Node3D
class_name BasePickable

signal item_picked_up(item_name:String,item_category:String,item_amount:float)

@export var radius:float=2.0
@export var data:PickableData
@export var amount:float=1.0

func _ready() -> void:
	$Area3D/CollisionShape3D.shape.radius=radius


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.has_node("Inventory"):
		var inv:Inventory=body.get_node("Inventory")
		inv.add_item(data.pickable_name,amount)
		var d=inv.get_item_data(data.pickable_name)
		if not d:
			inv.add_item_data(data.duplicate())
		item_picked_up.emit(data.pickable_name,data.pickable_category,amount)
		queue_free()
	pass # Replace with function body.
