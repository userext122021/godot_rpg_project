extends Node
class_name Interactable

signal interacted(body: Node3D)

@export var interact_text: String = "E - interact"
@export var category:String="unknown"
@export var data:InteractableData


func _ready() -> void:
	if data:
		interact_text=data.interaction_text
		category=data.category
func get_interaction_text():
	return interact_text
	
func get_category() -> String:
	return category
	
func interact(body: Node3D):
	interacted.emit(body)
	_on_interact(body)

# Эту функцию можно переопределять в дочерних скриптах
func _on_interact(_body: Node3D):
	print("DEBUG: interact")
	if "is_interacting" in _body:
		_body.is_interacting=false
	pass
