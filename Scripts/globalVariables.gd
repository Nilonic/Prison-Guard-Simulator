extends Node

var hp: int = 0
var lust: int = 0
var armour: int = 0
var xp: int = 0
var _xpPerLevel = 400

func _ready():
	print("initialized res://Scripts/globalVariables.gd as \"autoload_script\"")

func get_xp_per_level():
	return _xpPerLevel
