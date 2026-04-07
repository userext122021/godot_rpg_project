extends Area3D
class_name BaseSpawner

@export var detection_radius:float=20
@export var max_spawn_interval:float=10
@export var scene:PackedScene
@export var max_count:int=1
@export var is_active:bool=true
@export var randomize_spawn_time:bool=false
var counter=0

var timer:float

func _ready() -> void:
	var cyl:CylinderShape3D=$CollisionShape3D.shape
	cyl.radius=detection_radius
	
func can_spawn() -> bool:
	if counter>=max_count:
		return false
	if not is_active:
		return false
	return true

func spawn():
	if not can_spawn():
		return
	if not scene:
		is_active=false
	var obj:Node3D=scene.instantiate()
	if not obj:
		return
	add_child(obj)
	var pos=global_position
	pos.y==0.5
	obj.global_position=pos
	obj.tree_exited.connect(on_object_destroy)
	counter+=1
	print("DEBUG: object spawned. counter = ",counter)

func on_object_destroy():
	if counter>0:
		counter-=1
		
func _process(delta: float) -> void:
	if not is_active:
		return
	timer-=delta
	if timer<=0:
		var t=max_spawn_interval
		if randomize_spawn_time:
			t=randf_range(1,max_spawn_interval)
		timer=t
		spawn() 
