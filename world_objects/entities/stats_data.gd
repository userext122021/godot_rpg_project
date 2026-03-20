extends Resource
class_name StatsData

@export var speed:float=5.0
@export var jump_speed:float=4.5
@export var max_hp:float=100
@export var tmp_hp:float=0
@export var tmp_stamina:float=0
@export var regen_hp_per_second:float=1
@export var regen_stamina_per_second:float=1
@export var max_stamina:float=100
@export var hp:float=max_hp
@export var stamina:float=max_stamina
@export var state_timers:Dictionary={"poisoned":0,"radiation":0}
