extends Node3D

var max_count:int=3
var counter:int=0
@export var enemy_scene:PackedScene
var timer:float=0
var max_time:float=10
@onready var player:BasePlayer=$TestPlayer

func _ready() -> void:
	player.tree_exited.connect(on_player_died)
	timer=randf()*max_time
	
func on_player_died():
	if get_tree():
		get_tree().quit()

func _process(delta: float) -> void:
	timer-=delta
	if timer<=0:
		spawn()
		timer=randf()*max_time
		
func spawn():
	if counter>=max_count:
		return
	if not enemy_scene:
		return
	var pos:Vector3
	pos.x=randf()*20.0-10
	pos.z=randf()*20.0-10
	
	pos.y=1
	var enemy:BaseEnemy=enemy_scene.instantiate()
	enemy.process_mode=Node.PROCESS_MODE_DISABLED
	add_child(enemy)
	enemy.tree_exited.connect(on_enemy_died)
	enemy.global_position=pos
	enemy.process_mode=Node.PROCESS_MODE_PAUSABLE
	counter+=1
	
func on_enemy_died():
	if counter>0:
		counter-=1
		print("DEBUG: counter ",counter)
