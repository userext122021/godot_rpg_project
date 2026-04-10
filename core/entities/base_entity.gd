extends CharacterBody3D
class_name BaseEntity



@export var entity_type:String="unknown"
@export var speed := 5.0
@export var walking_speed := 5.0
@export var running_speed := 15.0

@export var jump_velocity := 4.5
@export var rotation_speed:float=3.0
@export var hp:float=20
@export var max_hp:float=20
@export var regen_hp_per_second:float=1.0
@export var weapon:BaseWeapon
#@export var detection_radius:float=10.0
@export var friction:float=100
@export var knockingback_interval:float=0.2
@export var animation_player:AnimationPlayer
var is_knockingback:bool=false
var knockback_timer:float=0
var is_attacking:bool=false
var is_moving:bool=false
var is_jumping:bool=false
var is_running:bool=false
var is_blocking:bool=false
var is_interacting:bool=false
var interacting_body:Node3D
var is_aiming:bool=false

func knock_back(knockback_force:float,weapon_pos:Vector3):
	print("DEBUG: knockback")
	var dir:Vector3=global_position.direction_to(weapon_pos)
	var angle=atan2(dir.z,dir.x)+PI/2.0
	dir.y=0
	velocity.x=-dir.x*knockback_force
	velocity.z=-dir.z*knockback_force
	is_knockingback=true
	knockback_timer=knockingback_interval

func can_move() -> bool:
	if is_attacking:
		return false
	if is_blocking:
		return false
	return true
func can_jump():
	if is_attacking:
		return false
	if is_on_floor():
		return true
	return false	

func can_run():
	if is_attacking:
		return false
	if is_jumping:
		return false
	if not is_moving:
		return false
	if is_blocking:
		return false
	return true
			
func can_attack():
	if not weapon:
		return false
	if is_jumping:
		return false
	if weapon.can_attack():
		return true
	return false
func can_aim():
	if is_attacking:
		return false
	if is_jumping:
		return false
	if is_running:
		return false
	return true
		
func _physics_process(delta: float) -> void:
	if is_knockingback:
		knockback_timer-=delta
		if knockback_timer<=0:
			is_knockingback=false
			return
		velocity = velocity.move_toward(Vector3.ZERO, friction * delta)	
		move_and_slide()
	if is_attacking:
		if weapon:
			if not weapon.is_active():
				is_attacking=false
		else:
			is_attacking=false
	if is_moving:
		if not can_move():
			is_moving=false
			
func _ready() -> void:
	#var shape:CylinderShape3D=$Area3D/CollisionShape3D.shape
	#shape.radius=detection_radius
	if weapon:
		set_current_weapon(weapon)
	print("DEBUG: entity init")
	
func calculate_damage(damage:float,damage_type:String) -> float:
	
	if is_blocking:
		return damage/2.0
	return damage
	
func take_hit(damage:float,damage_type:String,knockback_force:float,weapon_pos:Vector3):
	var calculated_damage:float=calculate_damage(damage,damage_type)
	print("DEBUG: taken hit ", damage_type," ",calculated_damage)
	
	hp-=calculated_damage
	if hp<=0:
		die()


func die():
	print("DEBUG: I am dying!")
	queue_free()
	
func attack():
	if can_attack():
		weapon.attack()
		is_attacking=true



func is_entity(body:Node3D) -> bool:
	if body==self:
		return false
	if "entity_type" in body:
		return true
	return false




func play_animation(anim_name:String):
	if animation_player.current_animation==anim_name and animation_player.is_playing():
		return
	if animation_player.has_animation(anim_name):
		animation_player.play(anim_name)
	

func update_animation():
	if not animation_player:
		return
	if is_attacking:
		if weapon:
			if not weapon.is_ranged:
				play_animation("melee_attack")
			else:
				play_animation("shoot")	
		return
	if is_jumping:
		play_animation("jump")	
		return
	if is_running:
		play_animation("run")
		return
	
	if is_blocking:
		play_animation("block")	
		return
	else:
		if animation_player.current_animation=="block":
			animation_player.stop()
	if is_moving:
		if can_move():
			play_animation("walk")
		return
	else:
		if animation_player.current_animation=="walk":
			animation_player.stop()
	if is_aiming:
		play_animation("pistol_idle")
	else:
		if animation_player.current_animation=="pistol_idle":
			animation_player.stop()
	if not animation_player.is_playing():
		play_animation("idle")
	
	

func set_current_weapon(w:BaseWeapon):
	if not w:
		weapon=null
		return
	weapon=w
	w.owner_body=self

func regen_hp(delta:float):
	hp+=regen_hp_per_second*delta
