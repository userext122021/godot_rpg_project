extends Control
class_name UI


@export var player:Player

func _ready() -> void:
	player.show_inventory.connect(show_inventory)
	pass
	

func show_inventory():
	print("INVENTORY: ",player.get_inventory().items)
	show_ui()
	
func show_ui():
	$ExitButton.show()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	pass

func hide_ui():
	$ExitButton.hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _on_exit_button_pressed() -> void:
	hide_ui()
	pass # Replace with function body.
