@tool
extends Node2D

const Classes = preload("res://scripts/peopls.gd")

@export var image: Texture2D:
	set(value):
		image = value
		# Only update if the node structure is loaded
		if is_inside_tree() and has_node("Sprite2D"):
			$Sprite2D.texture = value

@export var stone: StoneResource
@onready var sprite = $Sprite2D

func _ready() -> void:
	# Always set the visual texture in the editor when loading the scene
	if sprite and image:
		sprite.texture = image
		
	# STOP HERE if we are just viewing this in the editor
	if Engine.is_editor_hint():
		return 
