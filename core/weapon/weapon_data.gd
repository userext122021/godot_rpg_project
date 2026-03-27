extends Resource
class_name WeaponData

enum WeaponType { MELEE, RANGED }
@export var weapon_type: WeaponType = WeaponType.MELEE

@export var weapon_name:String="unknown"
@export var weapon_category:String="unknown"
@export var weapon_type:WeaponType=WeaponType.MELEE
@export var damage:float=3.0
@export var cooldown_time:float=1.0
@export var attack_time:float=1.0
@export var range:float=2.0
@export var knockback_force:float=0.0
