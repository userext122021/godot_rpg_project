extends Node
class_name StatsControl


signal died
signal damage_taken(damage:float)
signal effect_applied(effect_name:String,damage:float)
@export var data:StatsData

var effects={}

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
	
func regen(delta):
	if data.hp<data.max_hp:
		data.hp+=data.regen_hp_per_second*delta
	if data.stamina<data.max_stamina:
		data.stamina+=data.regen_stamina_per_second*delta
		
func update_effects(delta):
	var to_delete=[]
	for key in effects.keys():
		var e=effects[key]
		e["tick_timer"]-=delta
		if e["tick_timer"]<=0:
			effect_applied.emit(key,e["damage"])
			take_damage(e["damage"],key)
			e["tick_timer"]=e["interval"]
		e["total_timer"]-=delta
		if e["total_timer"]<=0:
			to_delete.append(key)
	for key in to_delete:
		effects.erase(key)
			
func add_effect(effect_name:String,duration:float,tick_time:float,damage:float):
	var effect={}
	effect["duration"]=duration
	effect["interval"]=tick_time
	effect["total_timer"]=duration
	effect["tick_timer"]=tick_time
	effect["damage"]=damage
	effects[effect_name]=effect


func has_effect(effect_name:String) -> bool:
	if effects.has(effect_name):
			return true
	return false
