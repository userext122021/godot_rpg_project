extends Node3D
class_name BaseWeapon

signal attack_started(weapon:BaseWeapon)
signal attack_finished(weapon:BaseWeapon)


@export var data:WeaponData
var is_attacking:bool=false
var is_cooldown:bool=false
var attack_timer:float=0
var cooldown_timer:float=0
var last_attack_damage:float=0.0

func _ready() -> void:
	$RayCast3D.target_position.z=-data.range
func _process(delta: float) -> void:
	if is_attacking:
		if $RayCast3D.is_colliding():
			var damage=hit($RayCast3D.get_collider())
			if damage>0.0:
				last_attack_damage=damage
				is_attacking=false
				is_cooldown=true
				cooldown_timer=data.cooldown_time
				attack_finished.emit(self)
				return
			
		attack_timer-=delta
		if attack_timer<=0:
			is_attacking=false
			is_cooldown=true
			cooldown_timer=data.cooldown_time
			attack_finished.emit(self)
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
	if not can_attack():
		return
	is_attacking=true
	attack_timer=data.attack_time
	attack_started.emit(self)

func can_attack() -> bool:
	if is_attacking:
		return false
	if is_cooldown:
		return false
	return true
		 
