extends Node3D

@onready var player:Player=$ExamplePlayer
func _ready() -> void:
	player.tree_exited.connect(on_player_died)
	#print("DEBUG: state_changed old:",old_state," new:",new_state)
	var inv=player.get_inventory()
	inv.add_item("stick",7)
	inv.add_item("stone",5)
	var stone_axe:RecipeData=RecipeData.new()
	stone_axe.recipe_name="stone_axe"
	stone_axe.ingredients["stone"]=2
	stone_axe.ingredients["stick"]=1
	stone_axe.result_name="stone_axe"
	inv.add_recipe("stone_axe",stone_axe)
	player.stats.data.hp*=0.7
	player.stats.data.stamina*=0.7

func on_player_died():
	if get_tree():
		get_tree().quit()
	pass
	
func _on_player_state_changed(new_state: BaseEntity.State, old_state: BaseEntity.State) -> void:
	
	pass # Replace with function body.
