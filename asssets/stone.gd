@tool
extends Node2D

const Classes = preload("res://scripts/peopls.gd")

@export var image: Texture2D:
	set(value):
		image = value
		# Only update if the node structure is loaded
		if is_inside_tree() and has_node("Sprite2D"):
			$Sprite2D.texture = value

# Initialize defaults carefully so they do not overwrite saved inspector data

@export var mats: Array[StoneMaterial] = []

@export var glitzern: bool
@export var fancyness: float
@export var shape: Classes.StoneShape

@onready var sprite = $Sprite2D
var stoneprops: Classes.StoneProps

func _ready() -> void:
	# Always set the visual texture in the editor when loading the scene
	if sprite and image:
		sprite.texture = image
		
	# STOP HERE if we are just viewing this in the editor
	if Engine.is_editor_hint():
		return 
	var color_dict = {}

	for i in mats.size():
		color_dict[mats[i].color] = mats[i].weight
	# Real gameplay initialization runs ONLY when playing the game
	stoneprops = Classes.StoneProps.new(color_dict, glitzern, shape, fancyness)
