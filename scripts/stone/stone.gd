@tool
extends Node2D

@onready var sprite: Sprite2D = $Sprite2D
@export var stone: StoneResource:
	set(value):
		stone = value
		if not is_inside_tree():
			await ready
		if sprite and value and value.image:
			sprite.texture = value.image


func set_sprite():
	# Always set the visual texture in the editor when loading the scene
	if sprite and stone:
		sprite.texture = stone.image
	

func _ready() -> void:	
	set_sprite()
	
	# STOP HERE if we are just viewing this in the editor
	if Engine.is_editor_hint():
		return
