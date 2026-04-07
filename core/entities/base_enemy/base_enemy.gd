extends BaseAIEntity
class_name BaseEnemy

func _ready() -> void:
	super._ready()
	entity_type="base_enemy"
	ai=BaseEnemyAI.new()
	ai.body=self
	ai.init_ai()
	
