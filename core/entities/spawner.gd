extends Area3D
class_name Spawner
signal object_spawned(object_body:Node3D)
@export var spawner_name:String="unknown_spawner"
@export var radius:float=10.0
@export var is_active:bool=true
@export var spawn_interval:float=10.0
@export var scene:PackedScene
@export var probability:float=1.0
var spawned_object:Node3D=null
var player_body:Node3D=null
var spawner_timer:float=0

func _ready() -> void:
	var c:CylinderShape3D=$CollisionShape3D.shape.duplicate()
	c.radius=radius	
	$CollisionShape3D.shape=c
	pass

	
func _process(delta: float) -> void:
	if not is_active:
		return
	if spawned_object:
		return
	if not player_body:
		return
	spawner_timer-=delta
	if spawner_timer<=0:
		spawner_timer=spawn_interval
		spawn()
		 
func spawn():
	if randf()>probability:
		return
	if not is_active:
		return
	if not player_body:
		return
	if global_position.distance_to(player_body.global_position)>radius:
		player_body=null
		return
	if spawned_object:
		return
	print("SPAWN")
	if not scene:
		printerr("[Spawner] ERROR: Scene is null")
		return
	spawned_object=scene.instantiate()
	add_child(spawned_object)
	spawned_object.global_position=global_position
	spawned_object.tree_exited.connect(_on_object_tree_exited)
	object_spawned.emit(spawned_object)
	pass


func _on_body_entered(body: Node3D) -> void:
	if not is_active:
		return
	print("Body entered ",body)
	if body.has_node("StatsControl"):
		var sc:StatsControl=body.get_node("StatsControl")
		if sc.data.entity_category=="player":
			spawner_timer=0
			player_body=body
	pass # Replace with function body.


func _on_body_exited(body: Node3D) -> void:
	if body==player_body:
		player_body=null
	pass # Replace with function body.





func _on_object_tree_exited():
	spawned_object=null
