extends Node
class_name Interactable

signal interacted(body: Node3D)

@export var interact_text: String = "E - interact"


func interact(body: Node3D):
	interacted.emit(body)
	_on_interact(body)

# Эту функцию можно переопределять в дочерних скриптах
func _on_interact(_body: Node3D):
	print("DEBUG: interact")
	pass
