@tool
extends InventoryItemListEditor


var recipe_item_map : Dictionary = {}

func load_items(database : InventoryDatabase) -> void:
	recipe_item_map.clear()
	for recipe in database.recipes:
		if is_instance_valid(recipe.product) and is_instance_valid(recipe.product.item):
			var id = database.get_id_from_item(recipe.product.item)
			if not recipe_item_map.has(id):
				var array : Array[Recipe] = []
				recipe_item_map[id] = array
			recipe_item_map[id].append(recipe)
	super.load_items(database)


func select(item_id : int):
	var idx = get_index_of_item_id(item_id)
	list.select(idx)


func update_item(index : int):
	var item_database = item_list_handler[index]
	var name_to_show : String 
	var icon : Texture2D = null
	var recipe_count = 0
	if item_database != null and item_database.item != null:
		if item_database.item.name.is_empty():
			name_to_show = "No name"
		else:
			name_to_show = item_database.item.name
		if recipe_item_map.has(item_database.id):
			recipe_count = recipe_item_map[item_database.id].size()
		icon = item_database.item.icon
	list.set_item_text(index, name_to_show +" ("+str(recipe_count)+")")
	list.set_item_disabled(index, recipe_count <= 0)
	list.set_item_selectable(index, recipe_count > 0)
	list.set_item_metadata(index, recipe_count)
	list.set_item_tooltip(index, str(recipe_count) + " recipes")
	list.set_item_icon(index, icon)
