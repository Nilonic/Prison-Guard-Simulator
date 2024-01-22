extends Node2D

# === Title Screen Stuff ===
var playButton: Button
var exitButton: Button
var titleScreen: CanvasGroup
var options: CanvasGroup
var updateText: RichTextLabel

# === toggles ===

# === screen default pos ===
var titleScreen_x: float 
var titleScreen_y: float 

# Called when the node enters the scene tree for the first time.
func _ready():
	# === set global variables to respective data ===
	playButton = $"Title Screen/playButton"
	exitButton = $"Title Screen/exitButton"
	titleScreen = $"Title Screen"
	options = $"Options"
	updateText = $"BackgroundDrawer/updateText"
	
	match OS.get_name():
		"Web":
			print_verbose("hiding exit button")
			exitButton.position.x = 999999999
			exitButton.position.y = 999999999
	
	# === listeners for buttons ===
	exitButton.connect("pressed", _exit_button_pressed)
	playButton.connect("pressed", _begin_game)
	
	# === screen position stuff ===
	titleScreen_x = titleScreen.position.x
	titleScreen_y = titleScreen.position.y
	
	# === check for updates. for now, just assume we're up to date TODO: make update checker code ===
	updateText.text = "Up To Date"
	
	# === hide option menu until i implement it
	options.visible = false
	options.position.x += 999999
	options.position.y += 999999
# Called every frame. '_deltaTime' is the elapsed time since the previous frame. would call it "_timeSinceLastFrame", but _deltaTime is quicker to type
func _process(_deltaTime):
	pass

func _exit_button_pressed():
	get_tree().quit(0)

func _begin_game():
	change_scene("res://Scenes/play.tscn")

func change_scene(target_scene_path:String):
	# Change the current scene to the specified scene
	var result: = get_tree().change_scene_to_file(target_scene_path)
	if result == ERR_CANT_OPEN:
		printerr("failed to load something. blame dev for something\nattempted to load: ", target_scene_path, " | got code: ERR_CANT_OPEN (ID: 19)")
	
