# GlobalFunctions.gd

extends Node

func update_text(root: Variant):
	find_node_by_name(root, "hpText").text = "[center]Pain: " + str(find_node_by_name(root, "hpBar").value) + "/100[/center]"
	find_node_by_name(root, "lustText").text = "[center]Lust: " + str(find_node_by_name(root, "lustBar").value)  + "/100[/center]"
	find_node_by_name(root, "armourText").text = "[center]Armour: " + str(find_node_by_name(root, "armourBar").value)  + "/100[/center]"
	find_node_by_name(root, "levelText").text = "[center]Level: " + str(do_level_calculation()) + "[/center]"

# Declare your global functions here
func set_health(new_health:int):
	# Your health-setting logic goes here
	#print("Setting health to: ", new_health)
	get_tree().get_root().get_node("Play").get_node("PlayerStatusBar").get_node("hpBar").value = new_health
func set_lust(new_lust:int):
	# Your health-setting logic goes here
	#print("Setting lust to: ", new_lust)
	get_tree().get_root().get_node("Play").get_node("PlayerStatusBar").get_node("lustBar").value = new_lust
func set_armour(new_armour:int):
	# Your health-setting logic goes here
	#print("Setting armour to: ", new_armour)
	get_tree().get_root().get_node("Play").get_node("PlayerStatusBar").get_node("armourBar").value = new_armour


# Recursively search for a node by name
func find_node_by_name(root, node_name):
# Check if the current node has the desired name
	if root.name == node_name:
		return root

# Check each child node recursively
	for i in range(root.get_child_count()):
		var child = root.get_child(i)
		var result = find_node_by_name(child, node_name)

# If the node is found in the current subtree, return it
		if result != null:
			return result

	# Node not found in the current subtree
	return null

func do_level_calculation():
	var level = GlobalVariables.xp / GlobalVariables.get_xp_per_level()
	return level + 1


var soundEffectPlayed = false

func _ready():
	print("initialized res://Scripts/globalFunctions.gd as \"autoload_script\"")

