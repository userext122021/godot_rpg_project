extends StaticBody3D

@export var scene:PackedScene




func _on_interactable_interacted(body: Node3D) -> void:
	if scene:
			var obj:Node3D=scene.instantiate()
			obj.process_mode=Node.PROCESS_MODE_DISABLED
			add_child(obj)
			obj.global_position=Vector3(randf()*40.0-20.0,0,randf()*40.0-20.0)
			obj.process_mode=Node.PROCESS_MODE_PAUSABLE
