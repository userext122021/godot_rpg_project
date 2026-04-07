extends BasePlayer
class_name TestPlayer

@onready var melee_weapon:BaseWeapon=$base_character/Armature/Skeleton3D/mixamorig_RightHandIndex1/weapon_marker/MeleeWeapon
@onready var ranged_weapon:BaseWeapon=$base_character/Armature/Skeleton3D/mixamorig_RightHandIndex1/weapon_marker/RangedWeapon

		

func _ready():
	super._ready()
	set_melee_weapon()
func set_melee_weapon():
	ranged_weapon.hide()
	melee_weapon.show()
	weapon=melee_weapon
func set_ranged_weapon():
	melee_weapon.hide()
	ranged_weapon.show()
	weapon=ranged_weapon	
	
func _physics_process(delta):
	if Input.is_action_just_pressed("select_item_1"):
		set_melee_weapon()
	if Input.is_action_just_pressed("select_item_2"):
		set_ranged_weapon()
	super._physics_process(delta)
