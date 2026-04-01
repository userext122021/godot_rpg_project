extends Node
class_name StatsControl

signal died
signal damage_taken(damage:float)
	
@export var data:StatsData
var status_timers={}
var status_total_timers={}

func calculate_damage(damage,damage_type) -> float:
	return damage

func take_damage(damage:float,damage_type:String="physical") -> float:
	var new_hp=data.hp
	var final_damage:float=calculate_damage(damage,damage_type)
	new_hp-=final_damage
	damage_taken.emit(final_damage)
	if new_hp<=0:
		new_hp=0
		emit_signal("died")
	data.hp=new_hp	
	print("DEBUG taking damage ",final_damage)
	return final_damage
	
func update(delta:float):
	regen(delta)
	pass
	
func update_statuses(delta:float):
	if status_timers.is_empty():
		return
	
	pass

func apply_effect(effect_name:String):
	if not data.statuses.has(effect_name):
		return
	var sd:StatusEffectData=data.statuses[effect_name]
	status_timers[effect_name]=0
	status_total_timers[effect_name]=0
	
func update_states(delta:float):
	pass
func regen(delta):
	if data.hp<data.max_hp:
		data.hp+=data.regen_hp_per_second*delta
	if data.stamina<data.max_stamina:
		data.stamina+=data.regen_stamina_per_second*delta
		
