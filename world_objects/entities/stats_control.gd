extends Node
class_name StatsControl

signal died
	
@export var data:StatsData

func take_damage(damage:float):
	var new_hp=data.hp
	new_hp-=damage
	if new_hp<=0:
		new_hp=0
		emit_signal("died")
	data.hp=new_hp	
	pass
	
func update(delta:float):
	pass
