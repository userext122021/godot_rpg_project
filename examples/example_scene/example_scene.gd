extends Node3D


func _on_player_state_changed(new_state: BaseEntity.State, old_state: BaseEntity.State) -> void:
	print("DEBUG: state_changed old:",old_state," new:",new_state)
	pass # Replace with function body.
