@tool
class_name StoneResource
extends Resource

@export var image: ImageTexture
@export var materials: Array[SMaterial]
@export var shiny: bool
@export var fancy: float
@export var surface: Surface
@export var shape: Shape

"""Surface property of a Stone"""
enum Surface{Smooth, Rough, Spikey}
"""Shape of a Stone"""
enum Shape{Round, Rect, Irregular}

"""
Material of a Stone
"""
class SMaterial extends Resource:
	@export var color: Color
	@export var weight: float
