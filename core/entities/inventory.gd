extends Node
class_name Inventory

signal item_used(item_name:String)

var items = {} # Формат: {"wood": 10.0}
var recipes = {} # Формат: {"axe": RecipeData}
var items_data={}

	
func add_item(item_name: String, amount: float):
	if items.has(item_name):
		items[item_name] += amount
	else:
		items[item_name] = amount

func add_item_data(data:PickableData):
	if items_data.has(data.pickable_name):
		return
	items_data[data.pickable_name]=data.duplicate()
	
func remove_item(item_name: String, amount: float):
	if items.has(item_name):
		items[item_name] -= amount
		if items[item_name] <= 0:
			items.erase(item_name) # Полностью удаляем предмет, если его 0

func get_amount_of(item_name: String) -> float:
	return items.get(item_name, 0.0)

func get_recipe(recipe_name: String) -> RecipeData:
	return recipes.get(recipe_name)

func has_item(item_name: String) -> bool:
	return items.has(item_name) and items[item_name] > 0
	
func has_recipe(recipe_name: String) -> bool:
	return recipes.has(recipe_name)
	
func can_craft(recipe_name: String) -> bool:
	var recipe = get_recipe(recipe_name)
	if not recipe: return false
	
	for ingredient in recipe.ingredients.keys():
		var required_amount = recipe.ingredients.get(ingredient)
		if get_amount_of(ingredient) < required_amount:
			return false
	return true

func craft(recipe_name: String):
	if not can_craft(recipe_name):
		return
		
	var recipe = get_recipe(recipe_name)
	# Убираем ресурсы
	for ingredient in recipe.ingredients.keys():
		remove_item(ingredient, recipe.ingredients.get(ingredient))
	
	# Добавляем результат (предполагаем, что в RecipeData есть result_name и result_amount)
	add_item(recipe.result_name, recipe.result_amount)


func add_recipe(recipe_name: String, recipe_data: RecipeData):
	recipes[recipe_name] = recipe_data

	
func use_item(item_name:String):
	if not has_item(item_name):
		return
	#if items_data.has(item_name):
	#	var data:PickableData=items_data[item_name]
	#	if data.is_usable:
	#		remove_item(item_name,1.0)
	#		item_used.emit(item_name)
	item_used.emit(item_name)

func get_item_data(item_name:String) -> PickableData:
	if items_data.has(item_name):
		return items_data[item_name]
	return null

func is_item_usable(item_name:String) -> bool:
	var d:PickableData=get_item_data(item_name)
	if not d:
		return false
	return d.is_usable
