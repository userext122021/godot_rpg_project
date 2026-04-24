extends StaticBody3D
class_name BaseStaticProp

@onready var collision:CollisionShape3D=$CollisionShape3D
@export var prop_name:String="base_static_prop"
@export var prop_category="base_static_prop_category"
@export var hp:float=10
@export var size:Vector3

func _ready() -> void:
	init_prop()

func init_prop():
	var box:BoxShape3D=$CollisionShape3D.shape
	box.size=size

func calculate_damage(damage:float,damage_type:String) -> float:
	return damage

	
func take_hit(damage:float,damage_type:String,knockback_force:float,weapon_pos:Vector3):
	var final_damage:float=calculate_damage(damage,damage_type)
	
	hp-=final_damage
	
	print("DEBUG: prop ",prop_name," taking hit. ",str(hp)," remains")
	if hp<=0:
		destroy()
	
	
func destroy():
	print("DEBUG: prop ",prop_name," destroying")
	queue_free()	
