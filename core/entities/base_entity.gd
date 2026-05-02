extends CharacterBody3D
class_name BaseEntity

@onready var inventory:Inventory=$Inventory

@export var entity_type:String="unknown"
@export var speed := 5.0
@export var walking_speed := 5.0
@export var running_speed := 15.0

@export var jump_velocity := 4.5
@export var rotation_speed:float=3.0
@export var hp:float=20
@export var max_hp:float=20
@export var regen_hp_per_second:float=1.0
@export var stamina:float=20
@export var max_stamina:float=20
@export var regen_stamina_per_second:float=1.0

@export var default_weapon:BaseWeapon
#@export var detection_radius:float=10.0
@export var friction:float=100
@export var knockingback_interval:float=0.2
@export var animation_player:AnimationPlayer
@export var weapon_marker:Node3D
@export var mass:float=60
@export var jump_cost:float=4.0
@export var running_cost_per_second:float=3.0

var current_weapon:BaseWeapon
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
	velocity.x=-dir.x*knockback_force/mass
	velocity.z=-dir.z*knockback_force/mass
	is_knockingback=true
	knockback_timer=knockingback_interval

func can_move() -> bool:
	if is_attacking:
		return false
	if is_blocking:
		return false
	return true
func can_jump():
	if stamina<jump_cost:
		return false
	if is_attacking:
		return false
	if is_on_floor():
		return true
	return false	

func can_run(delta:float):
	if stamina<=running_cost_per_second*delta:
		return false
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
	if not current_weapon:
		return false
	if is_jumping:
		return false
	if current_weapon.data.attack_cost>stamina:
		return false
	if current_weapon.can_attack():
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
		if current_weapon:
			if not current_weapon.is_active():
				is_attacking=false
		else:
			is_attacking=false
	if is_moving:
		if not can_move():
			is_moving=false
			
func _ready() -> void:
	#var shape:CylinderShape3D=$Area3D/CollisionShape3D.shape
	#shape.radius=detection_radius
	if default_weapon:
		#set_current_weapon(default_weapon)
		current_weapon=default_weapon
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
	if knockback_force and not is_knockingback:
		knock_back(knockback_force,weapon_pos)
		


func die():
	print("DEBUG: I am dying!")
	queue_free()
	
func attack():
	if can_attack():
		current_weapon.attack()
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
		if current_weapon:
			if not current_weapon.is_ranged:
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
	
	

func set_current_weapon(w:BaseWeapon) -> bool:
	if w==current_weapon:
		return false
	if not w:
		current_weapon=null
		return false
	if current_weapon:
		current_weapon.queue_free()
	current_weapon=w
	current_weapon.owner_body=self
	if current_weapon.get_parent():
		current_weapon.get_parent().remove_child(current_weapon)
	
	if weapon_marker:
		weapon_marker.add_child(current_weapon)
	else:
		add_child(current_weapon)
	current_weapon.position=current_weapon.start_position
	current_weapon.rotation=PI*current_weapon.start_rotation/180.0
	print("DEBUG: weapon_position ",current_weapon.position)
	print("DEBUG: weapon_rotation ",current_weapon.rotation)
	return true
		
func regen_hp(delta:float):
	hp+=regen_hp_per_second*delta
func  regen_stamina(delta:float):
	stamina+=regen_stamina_per_second*delta

func spend_stamina(delta:float):
	if is_running and stamina>running_cost_per_second*delta:
		stamina-=running_cost_per_second*delta

			
func equip_item_by_name(item_name:String) -> bool:
	var d:PickableData=inventory.get_item_data(item_name)
	if not d:
		return false
	return equip_item_by_data(d)

func equip_item(item_body:Node3D) -> bool:
	if not item_body:
		return false
	item_body.queue_free()
	print("STUB: equip_item need to be replaced")
	return false
	
func equip_item_by_data(item_data:PickableData) -> bool:
	if not item_data:
		return false
	if not item_data.scene:
		return false
	
	if item_data.pickable_category=="weapon":
		var w:BaseWeapon=item_data.scene.instantiate()
		if not w is BaseWeapon:
			w.queue_free()
			return false
		return set_current_weapon(w)
		
	if not item_data.is_equipable:
		return false
	var item_body:Node3D=item_data.scene.instantiate()
	return equip_item(item_body)
	

func take_item_by_name(item_name:String,amount:float=1.0) -> bool:
	if not inventory.get_item_data(item_name):
		print("WARNING: there is no item data of ",item_name)
	inventory.add_item(item_name,amount)
	return true

func take_item_by_data(item_data:PickableData,amount:float=1.0) -> bool:
	if not item_data:
		return false
	if amount<=0:
		return false
		
	var item_name:String=item_data.pickable_name
	if not inventory	.get_item_data(item_name):
		inventory.add_item_data(item_data)
	inventory.add_item(item_name,amount)
	return true
