extends BaseEntity
class_name Player

var mouse_sensitivity:float=0.002
@onready var camera = $CameraPivot/Camera3D

func _ready():
	super._ready()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED # Прячем курсор

func _unhandled_input(event):
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
	# Вращение головой через мышь
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		camera.rotate_x(-event.relative.y * mouse_sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += get_gravity().y * delta
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		#set_state(State.JUMP)
		is_jumping=true
		velocity.y = stats.data.jump_speed
	
	if is_on_floor() and current_state==State.JUMP:
		is_jumping=false
		#unset_state(State.JUMP)
			
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * stats.data.speed
		velocity.z = direction.z * stats.data.speed
		#set_state(State.WALK)
		is_walking=true
	else:
		#unset_state(State.WALK)
		is_walking=false
		velocity.x = move_toward(velocity.x, 0, stats.data.speed)
		velocity.z = move_toward(velocity.z, 0, stats.data.speed)
	
	move_and_slide()
	update_state()
