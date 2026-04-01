extends Node
class_name StatsControl

signal died
signal damage_taken(damage:float)
	
@export var data:StatsData
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
		
