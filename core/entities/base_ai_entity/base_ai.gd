extends Node
class_name BaseAI


var body:BaseAIEntity
var target:Vector3
var is_move_to_target:bool=false
var player_body:BasePlayer=null
var minimal_distance:float=2.0
var is_target_reached:bool=false
var is_active:bool=true

func is_player_nerby() -> bool:
	if not player_body:
		return false
	if body.global_position.distance_to(player_body.global_position)<minimal_distance:
		return true
	return false
	
func update(delta:float):
	if not is_active:
		return
	if not player_body:
		is_move_to_target=false
		is_target_reached=false
		return
	if not is_player_nerby():
		is_target_reached=false
		is_move_to_target=true
		target=player_body.global_position
		return
	if is_target_reached:
		#print("DEBUG: target is reached")
		body.attack()


func on_entity_entered(e:BaseEntity):
	if e.entity_type=="player":
		player_body=e
		#print("DEBUG: player entered")
		
func on_entity_exited(e:BaseEntity):
	if e==player_body:
		player_body=null
		print("DEBUG: player exited")

func init_ai():
	body.entity_entered.connect(on_entity_entered)
	body.entity_exited.connect(on_entity_exited)
