extends Node2D

var lasttime = 0
@onready var sky = $sky

@export var speed: float = 2.0
var time: float = -1.0
var dawn = -1
var days = 0
var speed_multiplier = 1         #multiplier how fast the days go

var daytime = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	lasttime =  Time.get_ticks_usec()
	time = dawn
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta * speed /10 / speed_multiplier
	
	#night 3
	#morning -2
	var offset_x: float = (cos(time) )  # Ranges 0.0 to 1.0
	var offset_y: float = (sin(time) )  # Ranges 0.0 to 1.0
	
	# Move the starting point (where the first color begins)
	if time <= 3*speed_multiplier:
		sky.texture.fill_from = Vector2(0.5, 1)
		sky.texture.fill_to = Vector2(1-offset_x, 1-offset_y)
	pass
	
func _input(event):
	if event.is_action_pressed("nextDay"):
		time = dawn*speed_multiplier
		days += 1
		print("hello")
