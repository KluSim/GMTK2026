@tool # 1. Added this to make the script run in the editor
extends Node2D

const Classes = preload("res://scripts/peopls.gd")

# 2. Added a setter to update the sprite texture when changed in inspector
@export var image: Texture2D:
	set(value):
		image = value
		if is_node_ready(): # Prevents errors before the node is fully loaded
			$Sprite2D.texture = value

#@export var stonepros: Classes.StoneProps
@export var color: Dictionary[Color, float] = {}
@export var glitzern: bool = false
@export var fancyness: float
@export var shape: Classes.StoneShape

@onready var sprite = $Sprite2D

var stoneprops: Classes.StoneProps

func _ready() -> void:
	# 3. Guard clause to prevent running game logic inside the editor
	if Engine.is_editor_hint():
		# Update the texture once when the scene opens in the editor
		if sprite and image:
			sprite.texture = image
		return 

	stoneprops = Classes.StoneProps.new(color, glitzern, shape, fancyness)
	sprite.texture = image
