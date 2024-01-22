extends Control

var commandBar: LineEdit

var console: RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	commandBar = $"LineEdit"
	console = $"RichTextLabel"
	set_process_input(true)

func _input(event):
	# Check if the event is a Key event and if the key pressed is Enter
	if event is InputEventKey and event.keycode == KEY_ENTER and event.pressed:
		# Enter key is pressed
		on_enter_pressed()

func on_enter_pressed():
	# Get the text from the LineEdit
	var text = commandBar.text.split(" ")
	
	# Do something with the text
	match text[0]:
		"help":
			commandBar.text = ""
			console.text += """\nhelp menu:
help - show help
show_scene <scene-ID> - change to a scene ID
load_scene <scene-ID> - mirror of show_scene
print_scene - print all scene Ids and their respective file paths"""
		"print_scene":
				console.text += "\nScene ID=1 -> Main Menu (res://Scenes/mainMenu.tscn)\nScene ID=2 -> Play (res://Scenes/play.tscn)\nScene ID=3 -> this scene (res://Scenes/debugConsole.tscn)"
				commandBar.text = ""
		"load_scene", "show_scene":
			if text.size() > 1:
				var scene_id = int(text[1])
				print(scene_id)
				console.text += "\nloading scene " + str(scene_id)
				commandBar.text = ""
				loadScene(scene_id)
			else:
				console.text += "\nmissing argument(s)"
				commandBar.text = ""
		_:
			if commandBar.text.strip_edges() != "":
				console.text += "\nunknown command \"" + commandBar.text + "\""
				commandBar.text = ""
			else:
				commandBar.text = ""

func loadScene(scene_id: int):
	match scene_id:
		1:
			change_scene("res://Scenes/mainMenu.tscn")
		2:
			change_scene("res://Scenes/play.tscn")
		3:
			change_scene("res://Scenes/debugConsole.tscn")
		_, 99999:
			console.text += "\nunknown scene ID \"" + str(scene_id) + "\""
			commandBar.text = ""


func change_scene(target_scene_path:String):
	# Change the current scene to the specified scene
	var result: = get_tree().change_scene_to_file(target_scene_path)
	if result == ERR_CANT_OPEN:
		printerr("failed to load something. blame dev for something\nattempted to load: ", target_scene_path, " | got code: ERR_CANT_OPEN (ID: 19)")
