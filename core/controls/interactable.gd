extends Node
class_name Interactable

signal interacted(body: Node3D)

@export var interact_text: String = "E - interact"
@export var data:InteractableData

func _ready() -> void:
	if data:
		interact_text=data.interaction_text

func get_interaction_text():
	if data:
		var text:String=data.interactable_name
		text+=" "
		text+=data.interaction_text
		return text
	return interact_text
	
func get_category() -> String:
	if not data:
		return "unknown"
	return data.interactable_category
	
func interact(body: Node3D):
	interacted.emit(body)
	_on_interact(body)

# Эту функцию можно переопределять в дочерних скриптах
func _on_interact(_body: Node3D):
	print("DEBUG: interact")
	pass
