extends Node2D

var lasttime = 0
@onready var sky = $sky
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	lasttime =  Time.get_ticks_usec()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var grad: Gradient = sky.texture.gradient
	var factor: float = (Time.get_ticks_usec()-lasttime)/10000000
	var yellow := Color(1.0, 0.9, 0.0) # Bright Yellow
	var blue := Color(0.0, 0.4, 1.0)   # Vivid Blue
	var color_1 = yellow.lerp(blue, factor)
	var color_2 = blue.lerp(blue, factor)
	
	# Update the two color stops of the gradient (Index 0 and Index 1)
	grad.set_color(0, color_1)
	grad.set_color(1, color_2)
	#if Time.get_ticks_usec() > 10000:
	#Godot
	
	pass
