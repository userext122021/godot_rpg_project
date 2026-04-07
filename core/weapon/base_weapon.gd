extends Node3D
class_name BaseWeapon

var is_preparing:bool=false
var is_attacking:bool=false
var is_cooldown:bool=false


@export var damage:float=7.0
@export var damage_type:String="physical"
@export var knockback_force:float=15.0

@export var preparing_interval:float=0.5
@export var attacking_interval:float=0.5
@export var cooldown_interval:float=0.5
@export var is_ranged:bool=false
@export var data:WeaponData
@export var range:float=1.0

var prep_timer:float=0
var attack_timer:float=0
var cooldown_timer:float=0
var owner_body:BaseEntity


func reload_data():
	damage=data.damage
	damage_type=data.damage_type
	knockback_force=data.knockback_force
	preparing_interval=data.preparing_interval
	attacking_interval=data.attacking_interval
	cooldown_interval=data.cooldown_interval
	is_ranged=data.is_ranged
	$RayCast3D.target_position.z=-data.range
	
func set_data(weapon_data:WeaponData):
	data=weapon_data.duplicate()
	reload_data()

func try_to_hit(body:Node3D) -> bool:
	#print("DEBUG: try to hit")
	if body:
		if owner_body:
			if body==owner_body:
				return false
		if body.has_method("take_hit"):
			body.take_hit(damage,damage_type,knockback_force,global_position)
			if knockback_force>0:
				if body.has_method("knock_back"):
					body.knock_back(knockback_force,global_position)
			return true
	return false		
func _process(delta: float) -> void:
	if is_preparing:
		prep_timer-=delta
		if prep_timer<=0:
			is_preparing=false
			is_attacking=true
			return
	if is_attacking:
		attack_timer-=delta
		if $RayCast3D.is_colliding():
			print("DEBUG: is colliding ",Time.get_ticks_msec())
			if try_to_hit($RayCast3D.get_collider()):
				is_attacking=false
				is_cooldown=true
		if attack_timer<=0:
			is_attacking=false
			is_cooldown=true
			return
		
	if is_cooldown:
		cooldown_timer-=delta
		if cooldown_timer<=0:
			is_cooldown=false

func can_attack() -> bool:
	if is_attacking:
		return false
	if is_preparing:
		return false
	if is_cooldown:
		return false
	return true
	
func attack():
	if not can_attack():
		return
	prep_timer=preparing_interval
	attack_timer=attacking_interval
	cooldown_timer=cooldown_interval
	is_preparing=true

func is_active():
	return is_preparing or is_attacking or is_cooldown
