extends BaseEntity
class_name BasePlayer

@export var mouse_sensitivity := 0.002
@export var interact_check_interval:float=0.5

@onready var camera = $Camera3D
@onready var inventory:Inventory=$Inventory
var interact_check_timer:float=0

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
	interact_check_timer-=delta
	if interact_check_timer<=0:
		interact_check_timer=interact_check_interval
		check_interacting()
	
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
		if weapon:
			if weapon.is_ranged:
				is_aiming=true
			else:
				is_blocking=true
		else:
			is_blocking=true
		
	else:
		is_blocking=false
		is_aiming=false
		
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if Input.is_action_just_pressed("interact"):
		interact()
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
	regen_hp(delta)
func die():
	print("DEBUG: player is dying")
	queue_free()

func check_interacting():
	if not $InteractRayCast.is_colliding():
		$InteractRayCast/Label3D.hide()
		interacting_body=null
		return
	var body:Node3D=$InteractRayCast.get_collider()
	if not body:
		return
	if not body.has_node("Interactable"):
		return
	var i:Interactable=body.get_node("Interactable")
	$InteractRayCast/Label3D.text=i.get_interaction_text()
	$InteractRayCast/Label3D.show()
	interacting_body=body

func interact():
	if not interacting_body:
		return
	if not interacting_body.has_node("Interactable"):
		return
	var i:Interactable=interacting_body.get_node("Interactable")
	i.interact(self)
	is_interacting=true
	pass
