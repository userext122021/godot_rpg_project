extends Node3D
class_name BasePickable

signal item_picked_up(item_name:String,item_category:String,item_amount:float)

@export var pickable_name:String="unknown_item"
@export var pickable_category:String="unknown_caqtegory"
@export var radius:float=2.0
@export var amount:float=1.0
@export var data:PickableData

func _ready() -> void:
	$Area3D/CollisionShape3D.shape.radius=radius


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.has_node("Inventory"):
		var inv:Inventory=body.get_node("Inventory")
		inv.add_item(pickable_name,amount)
		var d=inv.get_item_data(pickable_name)
		if not d:
			if data:
				inv.add_item_data(data.duplicate())
		item_picked_up.emit(pickable_name,pickable_category,amount)
		queue_free()
	pass # Replace with function body.
