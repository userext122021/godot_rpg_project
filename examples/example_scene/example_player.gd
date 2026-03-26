extends Player


func _ready():
	super._ready()
	var pickable_scene=load("res://examples/example_scene/default_pickable.tres")
	var pickable:PickableData=pickable_scene.duplicate()
	$Inventory.add_item_data(pickable)


func _on_inventory_item_used(item_name: String) -> void:
	if item_name=="stone":
		print("Mmm stone!")
		$Inventory.remove_item(item_name,1.0)
	pass # Replace with function body.
