@tool
class_name StoneResource
extends Resource

@export var image: Texture2D
@export var materials: Array[StoneMaterialResource]
@export var shiny: bool
@export var fancy: float
@export var surface: Surface
@export var shape: Shape
@export var name: String

"""Surface property of a Stone"""
enum Surface{Smooth, Rough, Spikey}
"""Shape of a Stone"""
enum Shape{Round, Rect, Irregular}
