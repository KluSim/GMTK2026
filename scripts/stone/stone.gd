@tool
extends Node2D

@export var stone: StoneResource:
	set(value):
		stone = value
		if value.image and sprite:
			sprite.texture = value.image
@onready var sprite = $Sprite2D

func set_sprite():
	# Always set the visual texture in the editor when loading the scene
	if sprite:
		sprite.texture = stone.image
	

func _ready() -> void:	
	set_sprite()
	
	# STOP HERE if we are just viewing this in the editor
	if Engine.is_editor_hint():
		return
