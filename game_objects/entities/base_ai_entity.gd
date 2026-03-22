extends BaseEntity
class_name BaseAIEntity

signal target_reached
signal entity_entered(body:Node3D)
signal entity_exited(body:Node3D)

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@export var target_position: Vector3
@export var minimal_distance: float = 1.5
@export var speed: float = 3.0
@export var ai:BaseAI
var is_target_reached:bool=false
func _ready() -> void:
	super._ready()
	nav_agent.path_desired_distance = 0.5
	nav_agent.target_desired_distance = minimal_distance
	$DetectionArea/CollisionShape3D.shape=$DetectionArea/CollisionShape3D.shape.duplicate()
	$DetectionArea/CollisionShape3D.shape.radius=stats.data.detection_radius

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	# 1. Применяем гравитацию
	if not is_on_floor():
		velocity.y += get_gravity().y * delta

	#if is_target_reached:
		#return

	# 2. Проверяем дистанцию до цели
	var dist = global_position.distance_to(target_position)
	#print("DEBUG: dist ",dist)
	# Если мы слишком далеко — идем, если близко — стоим
	if dist > minimal_distance:
		is_target_reached=false
		move_to_target(delta)
	else:
		if not target_reached:
			target_reached.emit()
		is_target_reached=true
		stop_moving()
	#print("DEBUG: base ai entity move and slide. velocity:",velocity)
	move_and_slide()
	update_state()
	if ai:
		ai._update(delta)

func move_to_target(delta: float):
	speed=stats.data.speed
	if global_position.distance_to(target_position)<minimal_distance:
		
		return
		
	rotate_towards_direction(delta)
	#$Pivot.look_at(target_position,up_direction,false)
	#global_rotation.y=$Pivot.global_rotation.y
	velocity.x=-basis.z.x*speed
	velocity.z=-basis.z.z*speed
	
	
	

func rotate_towards_direction(delta: float):
	$Pivot.look_at(target_position,up_direction,false)
	
	rotation.y =  lerp_angle(global_rotation.y, $Pivot.global_rotation.y, stats_data.rotation_speed*delta)
		
func stop_moving():
	velocity.x = move_toward(velocity.x, 0, speed)
	velocity.z = move_toward(velocity.z, 0, speed)
	is_walking = false


func _on_detection_area_body_entered(body: Node3D) -> void:
	if not body.has_node("StatsControl"):
		return
	entity_entered.emit(body)
	pass # Replace with function body.


func _on_detection_area_body_exited(body: Node3D) -> void:
	entity_exited.emit(body)
	pass # Replace with function body.
