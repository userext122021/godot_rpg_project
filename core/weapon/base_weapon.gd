extends Node3D
class_name BaseWeapon

@onready var raycast:RayCast3D=$RayCast3D
signal attack_started(weapon:BaseWeapon)
signal attack_finished(weapon:BaseWeapon)


@export var data:WeaponData
var is_attacking:bool=false
var is_cooldown:bool=false
var is_preparing:bool=false
var attack_timer:float=0
var cooldown_timer:float=0
var prepare_attack_timer:float=0
var last_attack_damage:float=0.0

func _ready() -> void:
	if data:
		update()

func _process(delta: float) -> void:
	if is_preparing:
		prepare_attack_timer-=delta
		if prepare_attack_timer<=0:
			is_preparing=false
			is_attacking=true
			attack_timer=data.attack_time
		return
	if is_attacking:
		attack_timer-=delta
		if raycast.is_colliding():
			if hit(raycast.get_collider()):
				stop_attack()
				return
		if attack_timer<=0:
			stop_attack()
			return
	if is_cooldown:
		cooldown_timer-=delta
		if cooldown_timer<=0:
			is_cooldown=false
			return

func hit(target_body:Node3D) -> bool:
	if not target_body:
		return false
	if not target_body.has_method("take_hit"):
		return false
	#target_body.take_damage(data.damage)
	last_attack_damage=target_body.take_hit(data,global_position)
	return true
	
func stop_attack():
	is_attacking=false
	is_preparing=false
	is_cooldown=true
	cooldown_timer=data.cooldown_time
	attack_finished.emit(self)

func update():
	if data and raycast:
		raycast.target_position.z=-data.range

func attack():
	if not can_attack():
		return

	#is_attacking=true
	#attack_timer=data.attack_time
	is_preparing=true
	prepare_attack_timer=data.prepare_attack_time
	attack_started.emit(self)

func can_attack() -> bool:
	if is_attacking:
		return false
	if is_cooldown:
		return false
	if is_preparing:
		return false
	return true
		 
