extends Node2D

var buttonTypeArray: Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	#check the current quest ID
	var qid = GlobalVariables.currentQuestID
	match qid:
		0:
			#we're in the intro scene, hard code time!
			var file = FileAccess.open("res://jsonSceneData/intro.json", FileAccess.READ)
			var json: JSON = JSON.new()
			var json_string
			# Check if the file was opened successfully
			if file != null:
				# Read the file content
				json_string = file.get_as_text()
				# Close the file
				file.close()
				# Parse the JSON string
				json.parse(json_string)
				print(json.data["data"]["character"])
				globalFunctions.find_node_by_name(get_tree().get_root(), "targetName").text = json.data["data"]["character"]
				globalFunctions.find_node_by_name(get_tree().get_root(), "tooltipThingy").tooltip_text = json.data["data"]["descriptor"]

				_setupButtons(json.data["buttonArray"])
			else:
				print("Failed to open the file.")
		_:
			print("unknown quest ID (future quest not started?)")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
func _setupButtons(jsonData: Dictionary) -> void:
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
				buttonTypeArray.append(buttonData["type"])
		else:
			print("Button node not found: ", buttonName)

