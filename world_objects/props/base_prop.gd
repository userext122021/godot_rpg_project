extends StaticBody3D
class_name BaseProp

signal prop_destroyed(prop_name:String,prop_group:String)
@export var data:PropData


func take_damage(damage:float):
	data.hp-=damage
	if data.hp<=0:
		destroy()


func destroy():
	prop_destroyed.emit(data.prop_name,data.prop_group)
	queue_free()
