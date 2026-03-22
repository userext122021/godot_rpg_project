extends Player


func _ready():
	super._ready()
	var pickable_scene=load("res://examples/example_scene/default_pickable.tres")
	var pickable:PickableData=pickable_scene.duplicate()
	$Inventory.add_item_data(pickable)
