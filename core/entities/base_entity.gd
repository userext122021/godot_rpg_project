extends CharacterBody3D
class_name BaseEntity

signal state_changed(new_state:State,old_state:State)
signal entity_died(entity_name:String,entity_category:String)

enum State {IDLE,WALK,RUN,JUMP,EXT}

@onready var stats:StatsControl=$StatsControl
@export var stats_data:StatsData
@export var max_rotation_x:float=PI/6
@export var weapon:BaseWeapon=null

@onready var anim_tree = $AnimationTree
@onready var anim_state_machine_playback:AnimationNodeStateMachinePlayback = anim_tree.get("parameters/playback")

var current_state:State=State.IDLE
var ext_state:String="NONE"

var is_walking:bool=false
var is_running:bool=false
var is_jumping:bool=false
var is_attacking:bool=false
var is_walk_attacking:bool=false
var is_run_attacking:bool=false
var is_jump_attacking:bool=false
var is_knockback:bool=false
var knockback_timer:float=0

func _ready() -> void:
	$MeshInstance3D.mesh=$MeshInstance3D.mesh.duplicate()
	$CollisionShape3D.shape=$CollisionShape3D.shape.duplicate()
	stats.data=stats_data.duplicate()
	stats_data=stats.data
	pass
func _physics_process(delta: float) -> void:
	if is_knockback:
		knockback_timer-=delta
		move_and_slide()
		if knockback_timer<=0:
			is_knockback=false
	pass
	
func set_state(new_state:State):
	if new_state==current_state:
		return
	if current_state==State.IDLE or current_state==State.WALK or current_state==State.RUN:
		state_changed.emit(new_state,current_state)
		current_state=new_state
		return
	elif current_state==State.JUMP:
		return
	pass

func unset_state(state:State):
	if current_state!=state:
		return
	state_changed.emit(State.IDLE,state)
	current_state=State.IDLE	
	
func update_state():
	var new_state:State=State.IDLE
	if is_jumping:
		new_state=State.JUMP
	elif is_running:
		new_state=State.RUN
	elif is_walking:
		new_state=State.WALK
	else:
		new_state=State.IDLE
	if new_state!=current_state:
		state_changed.emit(new_state,current_state)
		current_state=new_state

func take_damage(damage:float,damage_type:String="physical") -> float:
	return stats.take_damage(damage,damage_type)

func take_hit(weapon_data:WeaponData,attacker_position:Vector3) -> float:
	#process other hit parameters
	var total_damage:float=take_damage(weapon_data.damage,weapon_data.damage_type)
	if weapon_data.adv_damage>0:
		total_damage+=take_damage(weapon_data.adv_damage,weapon_data.adv_damage_type)

	# Применяем физику отталкивания
	if weapon_data.knockback_force > 0 and stats.data.mass > 0:
		var knock_dir = (global_position - attacker_position).normalized()
		knock_dir.y = 0 
		
		# Формула: Сила / Масса (Второй закон Ньютона в упрощении)
		var force = weapon_data.knockback_force / stats.data.mass
		velocity += knock_dir * force
		is_knockback=true
		knockback_timer=stats.data.knockback_time
	return total_damage


func attack():
	if weapon:
		if weapon.can_attack():
			#print("DEBUG: attack")
			is_attacking=true
			weapon.attack()

func die():
	entity_died.emit(stats.data.entity_name,stats.data.entity_category)
	queue_free()


func _on_stats_control_died() -> void:
	die()
	pass # Replace with function body.

func update_animations():
	var sm:AnimationNodeStateMachinePlayback=anim_state_machine_playback
	if is_jumping:
		sm.travel("jump")
	elif is_running:
		sm.travel("run")
	elif is_attacking:
		sm.travel("attack")
	elif is_walking:
		sm.travel("walk")
	else:
		sm.travel("idle") 
		
