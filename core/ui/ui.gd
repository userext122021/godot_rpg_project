extends Control
class_name UI

@onready var hp_progress_bar:ProgressBar=$HpProgressBar
@onready var stamina_progress_bar:ProgressBar=$StaminaProgressBar

@export var player_body:BasePlayer
@export var update_interval:float=0.5
var update_timer:float=0

func update_stats():
	if not player_body:
		return
	hp_progress_bar.max_value=player_body.max_hp
	hp_progress_bar.value=player_body.hp
	stamina_progress_bar.max_value=player_body.max_stamina
	stamina_progress_bar.value=player_body.stamina
		
func _process(delta: float) -> void:
	update_timer-=delta
	if update_timer<=0:
		update_timer=update_interval
		update_stats()
