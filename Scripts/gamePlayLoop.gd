extends Node2D

var buttonTypeArray: Array = []

var json: JSON = JSON.new()
var json_string
var current_block: int

# Called when the node enters the scene tree for the first time.
func _ready():
	#clear all buttons of text
	_clear_buttons()
	#check the current quest ID
	var qid = GlobalVariables.currentQuestID
	match qid:
		0:
			#we're in the intro scene, hard code time!
			current_block = 1
			var file = FileAccess.open("res://jsonSceneData/intro.json", FileAccess.READ)
			# Check if the file was opened successfully
			if file != null:
				# Read the file content
				json_string = file.get_as_text()
				# Close the file
				file.close()
				# Parse the JSON string
				json.parse(json_string)
				# set stuff up
				globalFunctions.find_node_by_name(get_tree().get_root(), "targetName").text = json.data["data"]["character"]
				globalFunctions.find_node_by_name(get_tree().get_root(), "tooltipThingy").tooltip_text = json.data["data"]["descriptor"]
				globalFunctions.find_node_by_name(get_tree().get_root(), "gameText").text = json.data["textBlock"][str(current_block)]["text"]
				set_char_sprite(json.data["data"]["characterSpritePath"])
				
				_setup_buttons(json.data["textBlock"][str(current_block)]["buttonArray"])
			else:
				print("Failed to open the file.")
		_:
			print("unknown quest ID (future quest not started?)")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
func _setup_buttons(jsonData: Dictionary) -> void:
	for buttonIndex in jsonData.keys():
		var buttonName = str(buttonIndex)
		var buttonData = jsonData[buttonIndex]
		
		# Find the button node by name
		var buttonNode = globalFunctions.find_node_by_name(get_tree().get_root(), buttonName)
		
		# Check if the button node exists
		if buttonNode != null:
		# Set properties based on the JSON data
			if "text" in buttonData:
				buttonNode.text = buttonData["text"]
			if "tooltip" in buttonData:
				buttonNode.tooltip_text = buttonData["tooltip"]
			if "type" in buttonData:
				match int(buttonData["type"]):
					1:
						buttonNode.connect("pressed", _to_next_text_block)
						buttonNode.disabled = false
					_, 0: # default case, or if type is zero
						buttonNode.disabled = true
		else:
			print("Button node not found: ", buttonName)

func _clear_buttons() -> void:
	for button in range(1, 13):
		globalFunctions.find_node_by_name(get_tree().get_root(), str(button)).text = ""
		globalFunctions.find_node_by_name(get_tree().get_root(), str(button)).tooltip_text = ""
		globalFunctions.find_node_by_name(get_tree().get_root(), str(button)).disconnect("pressed", _to_next_text_block)

func set_char_sprite(spriteName):
	var texture_path = spriteName + "/char.png"
	# Assuming get_tree().get_root() returns the root node of your scene
	var target_sprite = globalFunctions.find_node_by_name(get_tree().get_root(), "targetSprite")
	# Load the texture resource from the specified path
	var texture = load(texture_path)
	# Check if the texture is loaded successfully before assigning it
	if texture:
		target_sprite.texture = texture
	else:
		print("Failed to load texture:", texture_path)


func _to_next_text_block():
	_clear_buttons()
	_setup_buttons(json.data["textBlock"][str(current_block+1)]["buttonArray"])
	globalFunctions.find_node_by_name(get_tree().get_root(), "gameText").text = json.data["textBlock"][str(current_block+1)]["text"]
	current_block += 1
