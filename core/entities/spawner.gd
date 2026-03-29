extends Area3D
class_name Spawner

@export var radius:float=10.0
@export var is_active:bool=true
@export var spawn_interval:float=10.0
@export var scene:PackedScene
var spawned_object:Node3D=null
var player_body:Node3D=null
var spawner_timer:float=0

func _ready() -> void:
	$Timer.wait_time=spawn_interval
	var shape:CylinderShape3D=$CollisionShape3D.shape
	shape.radius=radius

func spawn():
	if not is_active:
		return
	if not player_body:
		return
	if global_position.distance_to(player_body.global_position)>radius:
		#is_active=false
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
	$Timer.stop()
	pass


func _on_body_entered(body: Node3D) -> void:
	if not is_active:
		return
	if body.has_node("StatsControl"):
		var sc:StatsControl=body.get_node("StatsControl")
		if sc.data.entity_category=="player":
			#is_active=true
			player_body=body
			$Timer.start()
	pass # Replace with function body.


func _on_body_exited(body: Node3D) -> void:
	if body.has_node("StatsControl"):
		var sc:StatsControl=body.get_node("StatsControl")
		if sc.data.entity_category=="player":
			#is_active=false
			player_body=null
			$Timer.stop()
	pass # Replace with function body.


func _on_timer_timeout() -> void:
	if not is_active:
		$Timer.stop()
		return
	spawn()
	pass # Replace with function body.


func _on_object_tree_exited():
	spawned_object=null
	if is_active:
		$Timer.start()
