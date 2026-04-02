extends BaseEntity
class_name BasePlayer

signal show_inventory
signal interaction_started


@export var interaction_interval:float=0.2
var interaction_timer:float=0
var mouse_sensitivity:float=0.002
@onready var camera = $CameraPivot/Camera3D
var interactable:Interactable=null
var interactable_body:Node3D
var current_workstation:String="none"

func _ready():
	super._ready()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED # Прячем курсор

func get_inventory() -> Inventory:
	return $Inventory
	
func _unhandled_input(event):
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
	# Вращение головой через мышь
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		camera.rotate_x(-event.relative.y * mouse_sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, -max_rotation_x, max_rotation_x)

func check_interaction(delta):
	interaction_timer-=delta
	if interaction_timer>0:
		return
	interaction_timer=interaction_interval	
	if $InteractRay.is_colliding():
		#print($InteractRay.get_collider())
		var i_body:Node3D=$InteractRay.get_collider()
		if i_body:
			if i_body.has_node("Interactable"):
				var i:Interactable=i_body.get_node("Interactable")
				interactable=i
				interactable_body=i_body
				$InteractRay/Label3D.text=i.get_interaction_text()
				$InteractRay/Label3D.show()
				return
			
	
	interactable=null
	interactable_body=null
	if $InteractRay/Label3D.visible:
		$InteractRay/Label3D.hide()
	pass
	
func interact():
	if interactable==null:
		return
	if interactable.get_category()=="workstation":
		current_workstation=interactable.get_interactable_name()
	interactable.interact(self)
	interaction_started.emit()
	
	
func _physics_process(delta):
	super._physics_process(delta)
	if not is_on_floor():
		velocity.y += get_gravity().y * delta
	if is_on_floor() and is_jumping:
		is_jumping=false
		#unset_state(State.JUMP)
	
	#if $InteractRay.is_colliding():
	check_interaction(delta)
	if Input.is_action_just_pressed("interact"):
		if not is_interaction:
			interact()
			#is_interaction=true
	if Input.is_action_just_pressed("show_inventory"):
		show_inventory.emit()
	
	if weapon:
		if is_attacking:
			if not weapon.is_attacking:
				is_attacking=false
	if Input.is_action_pressed("attack"):
		attack()		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		#set_state(State.JUMP)
		is_jumping=true
		velocity.y = stats.data.jump_speed
	
	if Input.is_action_pressed("run"):
		is_running=true
	elif not Input.is_action_pressed("run"):
		is_running=false		
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
	
