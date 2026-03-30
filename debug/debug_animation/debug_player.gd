extends BasePlayer
@onready var anim_tree = $AnimationTree
@onready var sm = anim_tree.get("parameters/playback")

func _physics_process(delta):
	super._physics_process(delta)
	update_animations()

func update_animations():
	#var sm=$AnimationTree.get("parameters/playback")
	
	if is_jumping:
		sm.travel("jump")
	elif is_running:
		sm.travel("run")
	elif is_attacking:
		sm.travel("attack")
	elif is_walking:
		sm.travel("walk")
	else:
		sm.travel("idle") 
		
