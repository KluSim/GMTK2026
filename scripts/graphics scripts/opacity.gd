extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$cobweb.self_modulate.a = 0.2
	$cobweb2.self_modulate.a = 0.2
	$beer.self_modulate = Color(0.7, 0.71, 0.69)
	pass # Replace with function body.
