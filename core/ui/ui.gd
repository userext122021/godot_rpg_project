extends Control
class_name UI


@export var player:Player

@onready var invenory_window=$MainWindow/HBoxContainer/InventoryWindow
@onready var item_list=$MainWindow/HBoxContainer/InventoryWindow/HBoxContainer/ItemList
@onready var amount_list=$MainWindow/HBoxContainer/InventoryWindow/HBoxContainer/AmountList
@onready var recipe_list=$MainWindow/HBoxContainer/CraftWindow/ListContainer/RecipeList


func _ready() -> void:
	player.show_inventory.connect(show_inventory)
	
	pass
	

func show_inventory():
	print("INVENTORY: ",player.get_inventory().items)
	show_ui()
	update_ui()
	invenory_window.show()
	
func clear_inventory_list():
	item_list.clear()
	amount_list.clear()

func fill_inventory_list():
	var inv:Inventory=player.get_inventory()
	for key in inv.items.keys():
		var amount:float=inv.items[key]
		item_list.add_item(key)
		amount_list.add_item(str(amount))	
func update_inventory_list():
	clear_inventory_list()
	fill_inventory_list()

func clear_craft_list():
	recipe_list.clear()
	
func fill_craft_list():
	var inv:Inventory=player.get_inventory()
	for key in inv.recipes.keys():
		recipe_list.add_item(key)
		
func update_craft_list():
	clear_craft_list()
	fill_craft_list()

func update_ui():
	update_inventory_list()	
	update_craft_list()
func show_ui():
	$MainWindow.show()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	pass

func hide_all_windows():
	invenory_window.hide()
func hide_ui():
	hide_all_windows()
	$MainWindow.hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _on_exit_button_pressed() -> void:
	hide_ui()
	pass # Replace with function body.

func get_active_item(list:ItemList) -> String:
	var r:String=""
	var arr=list.get_selected_items()
	if arr.is_empty():
		return r
	return list.get_item_text(arr[0])
	
func _on_craft_button_pressed() -> void:
	var recipe=get_active_item(recipe_list)
	if recipe!="":
		player.get_inventory().craft(recipe)	
	update_ui()
	pass # Replace with function body.


func _on_use_button_pressed() -> void:
	player.get_inventory().use_item(get_active_item(item_list))
	update_ui()
	pass # Replace with function body.
