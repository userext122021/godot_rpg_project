extends Node3D
class_name BaseWeapon

signal attack_started(weapon_body:Node3D)
signal attack_finished(weapon_body:Node3D)


@export var data:WeaponData
var is_attacking:bool=false
var is_cooldown:bool=false
var attack_timer:float=0
var cooldown_timer:float=0

func _ready() -> void:
	$RayCast3D.target_position.z=-data.range
func _process(delta: float) -> void:
	if is_attacking:
		if $RayCast3D.is_colliding():
			if hit($RayCast3D.get_collider()):
				is_attacking=false
				is_cooldown=true
				cooldown_timer=data.cooldown_time
				return
			
		attack_timer-=delta
		if attack_timer<=0:
			is_attacking=false
			is_cooldown=true
			cooldown_timer=data.cooldown_time
			return
	if is_cooldown:
		cooldown_timer-=delta
		if cooldown_timer<=0:
			is_cooldown=false
			return

func hit(target_body:Node3D) -> float:
	if not target_body:
		return 0.0
	if not target_body.has_method("take_hit"):
		return 0.0
	
	#target_body.take_damage(data.damage)
	return target_body.take_hit(data,global_position)
	

func attack():
	if not can_attck():
		return
	is_attacking=true
	attack_timer=data.attack_time

func can_attck() -> bool:
	if is_attacking:
		return false
	if is_cooldown:
		return false
	return true
		 
