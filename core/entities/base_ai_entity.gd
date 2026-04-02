extends BaseEntity
class_name BaseAIEntity

signal target_reached
signal entity_entered(body:Node3D)
signal entity_exited(body:Node3D)

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@export var target_position: Vector3
@export var minimal_distance: float = 1.5
#@export var speed: float = 3.0
@export var ai:BaseAI
var is_target_reached:bool=false
func _ready() -> void:
	super._ready()
	nav_agent.path_desired_distance = 1.5
	nav_agent.target_desired_distance = minimal_distance
	$DetectionArea/CollisionShape3D.shape=$DetectionArea/CollisionShape3D.shape.duplicate()
	$DetectionArea/CollisionShape3D.shape.radius=stats.data.detection_radius

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	if is_knockback:
		return
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
		if not is_target_reached:
			target_reached.emit()
		is_target_reached=true
		stop_moving()
	#print("DEBUG: base ai entity move and slide. velocity:",velocity)
	move_and_slide()
	update_state()
	if ai:
		ai._update(delta)

func move_to_target(delta: float):
	# 1. Обновляем цель в агенте только если она реально изменилась
	if nav_agent.target_position != target_position:
		nav_agent.target_position = target_position
	#print("Path points count: ", nav_agent.get_current_navigation_path().size())
	# 2. Если агент считает, что пришел — сбрасываем скорость и выходим
	if nav_agent.is_navigation_finished():
		stop_moving()
		return

	# 3. Получаем следующую точку пути
	var next_pos: Vector3 = nav_agent.get_next_path_position()
	rotate_towards_position(next_pos,delta)
	# 4. Рассчитываем направление (только по горизонтали XZ)
	var dir = global_position.direction_to(next_pos)
	dir.y = 0 
	dir = dir.normalized()
	
	# 5. Если мы не стоим на месте (есть куда идти)
	if dir.length() > 0.01:
		# Применяем скорость из конфига статов
		var current_speed = stats.data.speed
		velocity.x = dir.x * current_speed
		velocity.z = dir.z * current_speed
		
		# Поворачиваем персонажа лицом к следующей точке пути
		#rotate_towards_position(next_pos, delta)
		is_walking = true
	else:
		stop_moving()

	
func move_direct_to_target(delta: float):
	var speed=stats.data.speed
	if global_position.distance_to(target_position)<minimal_distance:
		return
		
	rotate_towards_position(target_position,delta)
	
	#$Pivot.look_at(target_position,up_direction,false)
	#global_rotation.y=$Pivot.global_rotation.y
	velocity.x=-basis.z.x*speed
	velocity.z=-basis.z.z*speed
	
	
	

func rotate_towards_position(pos:Vector3, delta: float):
	if pos==global_position:
		return
	$Pivot.look_at(pos,up_direction,false)
	
	rotation.y =  lerp_angle(global_rotation.y, $Pivot.global_rotation.y, stats_data.rotation_speed*delta)
		
func stop_moving():
	velocity.x = move_toward(velocity.x, 0, stats.data.speed)
	velocity.z = move_toward(velocity.z, 0, stats.data.speed)
	is_walking = false


func _on_detection_area_body_entered(body: Node3D) -> void:
	if not body.has_node("StatsControl"):
		return
	entity_entered.emit(body)
	pass # Replace with function body.


func _on_detection_area_body_exited(body: Node3D) -> void:
	entity_exited.emit(body)
	pass # Replace with function body.
