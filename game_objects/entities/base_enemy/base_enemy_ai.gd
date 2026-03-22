extends BaseAI
var player_body:BaseEntity

func _ready() -> void:
	super._ready()
	body.ai=self
	print("DEBUG: base AI ready")

func _process(delta: float) -> void:
	if body.is_target_reached:
		if body.weapon:
			body.attack()		

func _on_target_reached():
	print("DEBUG: base enemy target reached")
	body.attack()

func _on_entity_entered(e_body:Node3D):
	var s:StatsControl=e_body.get_node("StatsControl")
	if s.data.entity_category=="player":
		player_body=e_body


func _update(delta):
	if player_body:
		body.target_position=player_body.global_position
	pass
