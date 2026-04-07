extends BaseAI
class_name BaseEnemyAI



var player_body:BasePlayer=null

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
	super.on_entity_entered(e)
	if e.entity_type=="player":
		player_body=e
		#print("DEBUG: player entered")
		
func on_entity_exited(e:BaseEntity):
	super.on_entity_exited(e)
	if e==player_body:
		player_body=null
		print("DEBUG: player exited")
