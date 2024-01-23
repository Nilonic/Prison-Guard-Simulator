extends Node2D

var playerHPBar : ProgressBar
var playerLustBar : ProgressBar
var playerArmourBar : ProgressBar
var playerLevelBar: ProgressBar

var root

var playerHPBarText : RichTextLabel
var playerLustBarText : RichTextLabel
var playerArmourBarText : RichTextLabel
var playerLevelBarText : RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	playerHPBar = $"hpBar"
	playerLustBar = $"lustBar"
	playerArmourBar = $"armourBar"
	
	playerHPBarText = $"hpBar/hpText"
	playerLustBarText = $"lustBar/lustText"
	playerArmourBarText = $"armourBar/armourText"
	
	root = get_tree().get_root()
	playerHPBar.value = GlobalVariables.hp
	playerLustBar.value = GlobalVariables.lust
	playerArmourBar.value = GlobalVariables.armour

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#update text here
	globalFunctions.update_text(root)
	_updatePlayerStatus()

func _updatePlayerStatus():
	pass #as we can't do it until i make the actual sprites
