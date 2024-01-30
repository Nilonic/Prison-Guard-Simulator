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
				globalFunctions.find_node_by_name(get_tree().get_root(), "tooltipTitle").text = "[center]" + json.data["data"]["character"]
				globalFunctions.find_node_by_name(get_tree().get_root(), "tooltipDescription").text = "[center]" + json.data["data"]["descriptor"]
				globalFunctions.find_node_by_name(get_tree().get_root(), "gameText").text = json.data["textBlock"][str(current_block)]["text"]
				set_char_sprite(json.data["data"]["characterSpritePath"])
				
				_setup_buttons(json.data["textBlock"][str(current_block)]["buttonArray"])
			else:
				print("Failed to open the file.")
		_:
			print("unknown quest ID (future quest not started?)")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
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
					2:
						buttonNode.connect("pressed", _to_char_creator)
						buttonNode.disabled = false
					3: # submit name
						buttonNode.connect("pressed", _save_name)
						buttonNode.disabled = false
					4: # submit gender
						buttonNode.connect("pressed", _save_gender)
						buttonNode.disabled = false
					_, 0: # default case, or if type is zero
						buttonNode.disabled = true
		else:
			print("Button node not found: ", buttonName)

func _clear_buttons() -> void:
	for button in range(1, 13): # mfw not inclusive
		globalFunctions.find_node_by_name(get_tree().get_root(), str(button)).text = ""
		globalFunctions.find_node_by_name(get_tree().get_root(), str(button)).tooltip_text = ""
		globalFunctions.find_node_by_name(get_tree().get_root(), str(button)).disabled = true
		# Disconnect the "pressed" signal from any connected callables
		var signal_name = "pressed"
		# Get all connections to the signal
		var connections = globalFunctions.find_node_by_name(get_tree().get_root(), str(button)).get_signal_connection_list(signal_name)
		# Disconnect each connection
		for connection in connections:
			print(connection)
			globalFunctions.find_node_by_name(get_tree().get_root(), str(button)).disconnect(signal_name, connection["callable"])


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

	var next_block_str = str(current_block + 1)

	if json.data["textBlock"].has(next_block_str):
		if json.data["textBlock"][next_block_str].has("buttonArray") and json.data["textBlock"][next_block_str].has("text"):
			_setup_buttons(json.data["textBlock"][next_block_str]["buttonArray"])
			globalFunctions.find_node_by_name(get_tree().get_root(), "gameText").text = json.data["textBlock"][next_block_str]["text"]
			current_block += 1
		else:
			globalFunctions.find_node_by_name(get_tree().get_root(), "gameText").text = "JSON Parse Error: \"" + next_block_str + "\" from key \"textBlock\" was not found, or is malformed, in JSON file
make sure that the button type is correct, and you have all required keys. visit https://github.com/Nilonic/Prison-Guard-Simulator/wiki/ for the schema"
	else:
		globalFunctions.find_node_by_name(get_tree().get_root(), "gameText").text = "JSON Parse Error: \"" + next_block_str + "\" from key \"textBlock\" was not found, or is malformed, in JSON file
make sure that the button type is correct, and you have all required keys. visit https://github.com/Nilonic/Prison-Guard-Simulator/wiki/ for the schema
"
		print("No data found for block", next_block_str)

func _to_char_creator():
	_clear_buttons()
	#name entry node
	globalFunctions.find_node_by_name(get_tree().get_root(), "gameText").text = "\n\nEnter your name:"
	var tentry: LineEdit = LineEdit.new()
	tentry.custom_minimum_size = Vector2(200, 40)
	tentry.name = "name_entry"
	tentry.position = Vector2(240, 80)
	tentry.max_length = 13
	tentry.placeholder_text = "name here (MAX 13)"
	tentry.text = "Player"
	add_child(tentry)
	# sorry future developer (whether it's me or someone else i don't know)
	_setup_buttons({"1":{ "text": "Submit", "type": 3}})


func _save_name(): # done =)
	if globalFunctions.find_node_by_name(get_tree().get_root(), "name_entry").text.strip_edges().to_lower() == "":
		print("ERR: Name cannot be empty")
	elif globalFunctions.find_node_by_name(get_tree().get_root(), "name_entry").text.strip_edges().to_lower() == "nilon":
		print("haha, very funny, but no")
	else:
		print("name:", globalFunctions.find_node_by_name(get_tree().get_root(), "name_entry").text)
		GlobalVariables.name = globalFunctions.find_node_by_name(get_tree().get_root(), "name_entry").text
		remove_child(globalFunctions.find_node_by_name(get_tree().get_root(), "name_entry"))
		_clear_buttons()
		globalFunctions.find_node_by_name(get_tree().get_root(), "gameText").text = "\n\nselect gender:"
		var tentry: OptionButton = OptionButton.new()
		tentry.name = "gender_bender"
		tentry.add_item("Male", 0); tentry.add_item("Female", 1)
		tentry.custom_minimum_size = Vector2(200, 40)
		tentry.position = Vector2(240, 80)
		tentry.select(0)
		add_child(tentry)
		_setup_buttons({"1":{ "text": "Submit", "type": 4}})
		
func _save_gender():
	print(globalFunctions.find_node_by_name(get_tree().get_root(), "gender_bender").get_selected_id()) # 0 = false, 1 = true
	if globalFunctions.find_node_by_name(get_tree().get_root(), "gender_bender").get_selected_id() == 0:
		pass
	else:
		GlobalVariables.playerGender = true
