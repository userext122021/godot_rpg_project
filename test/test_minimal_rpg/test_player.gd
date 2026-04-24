extends BasePlayer


func  _physics_process(delta):
	super._physics_process(delta)
	if Input.is_action_just_pressed("item_1"):
		#print(inventory.get_node_by_item_name("test_club"))
		equip_item("test_club")
	update_animation()
	
