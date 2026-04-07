extends Control
class_name UI

@onready var hp_progress_bar:ProgressBar=$HpProgressBar

@export var player_body:BasePlayer
@export var update_interval:float=0.5
var update_timer:float=0

func update_stats():
	if not player_body:
		return
	hp_progress_bar.max_value=player_body.max_hp
	hp_progress_bar.value=player_body.hp
	#print(hp_progress_bar.value)
		
func _process(delta: float) -> void:
	update_timer-=delta
	if update_timer<=0:
		update_timer=update_interval
		update_stats()
