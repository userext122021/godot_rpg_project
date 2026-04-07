extends BaseEntity
class_name BaseAIEntity

signal entity_entered(e:BaseEntity)
signal entity_exited(e:BaseEntity)

@export var detection_radius:float=10
var ai:BaseAI


func _ready() -> void:
	super._ready()
	entity_type="ai_entity"
	ai=BaseAI.new()
	ai.body=self
	ai.init_ai()
	var shape:CylinderShape3D=$Area3D/CollisionShape3D.shape
	shape.radius=detection_radius

func get_next_point() -> Vector3:
	return ai.target
		
func rotate_to_point(point:Vector3,delta:float):
	var dir=global_position.direction_to(point)
	#print("DEBUG: dir",dir)
	var angle=-atan2(dir.z,dir.x)-PI/2.0
	rotation.y=lerp_angle(rotation.y,angle,rotation_speed*delta)
	
func _physics_process(delta: float) -> void:
	ai.update(delta)
	super._physics_process(delta)
	if is_knockingback:
		return
	if not is_on_floor():
		velocity.y += get_gravity().y * delta
		
	if ai.is_move_to_target:
		if global_position.distance_to(ai.target)<ai.minimal_distance:
			ai.is_target_reached=true
			is_moving=false
		else:
			var next_point:Vector3=get_next_point()	
			rotate_to_point(next_point,delta)
			#print("DEBUG: angle ",180.0*angle/PI)
			velocity.x=-basis.z.x*speed
			velocity.z=-basis.z.z*speed
			is_moving=true
	else:
		is_moving=false
	if is_attacking:
		rotate_to_point(ai.target,delta)
	
	if not is_moving:		
		var vy=velocity.y
		velocity = velocity.move_toward(Vector3.ZERO, friction * delta)
		velocity.y=vy
	move_and_slide()


func on_entity_entered(e:BaseEntity):
	#print("DEBUG: entity entered ",e)
	entity_entered.emit(e)

func on_entity_exited(e:BaseEntity):
	#print("DEBUG: entity exited ",e)
	entity_exited.emit(e)

func _on_area_3d_body_entered(body: Node3D) -> void:
	if is_entity(body):
		on_entity_entered(body)
		#print("DEBUG: body is entity ",e.entity_type)
	pass # Replace with function body.



func _on_area_3d_body_exited(body: Node3D) -> void:
	if is_entity(body):
		on_entity_exited(body)
