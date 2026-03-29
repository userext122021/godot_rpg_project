extends Node
class_name StatsControl

signal died
signal damage_taken(damage:float)
	
@export var data:StatsData

func take_damage(damage:float) -> float:
	var new_hp=data.hp
	new_hp-=damage
	if new_hp<=0:
		new_hp=0
		emit_signal("died")
	data.hp=new_hp	
	damage_taken.emit(damage)
	print("DEBUG taking damage ",damage)
	return damage
	
func update(delta:float):
	pass

func regen(delta):
	if data.hp<data.max_hp:
		data.hp+=data.regen_hp_per_second*delta
	if data.stamina<data.max_stamina:
		data.stamina+=data.regen_stamina_per_second*delta
		
