extends Node
class_name StatsControl

signal died
signal damage_taken(damage:float)
	
@export var data:StatsData

func take_damage(damage:float):
	print("DEBUG taking damage ",damage)
	var new_hp=data.hp
	new_hp-=damage
	if new_hp<=0:
		new_hp=0
		emit_signal("died")
	data.hp=new_hp	
	damage_taken.emit(damage)
	pass
	
func update(delta:float):
	pass
