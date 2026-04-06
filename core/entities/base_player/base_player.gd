extends BaseEntity
class_name BasePlayer

@export var mouse_sensitivity := 0.002

@onready var camera = $Camera3D

func _ready():
	super._ready()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED # Прячем курсор
	entity_type="player"

func _unhandled_input(event):
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
	# Вращение головой через мышь
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		camera.rotate_x(-event.relative.y * mouse_sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)

func _physics_process(delta):
	super._physics_process(delta)
	if not is_on_floor():
		velocity.y += get_gravity().y * delta
	
	if is_jumping and is_on_floor():
		is_jumping=false
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		if can_jump():
			velocity.y = jump_velocity
			is_jumping=true
	if Input.is_action_pressed("run"):
		if can_run():
			is_running=true
			speed=running_speed
	else:
		is_running=false	
		speed=walking_speed
	if Input.is_action_pressed("block"):
		is_blocking=true
	else:
		is_blocking=false
		
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if Input.is_action_pressed("attack"):
		attack()
	if direction:
		if can_move():
			is_moving=true
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
	else:
		is_moving=false
	
	if not is_moving:	
		velocity.x = move_toward(velocity.x, 0, friction*delta)
		velocity.z = move_toward(velocity.z, 0, friction*delta)
	
	move_and_slide()
	update_animation()
	
func die():
	print("DEBUG: player is dying")
