extends Sprite2D
@onready var area2D = $Area2D
@onready var stones = $"../../../../Allstones"
@onready var stone_render = $"../../../../stones"

var steine_Liste =  []

var is_dragging = false #check if the stone is currently getting dragged, only spawn afterwards

var time_delay = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#time_delay = Time.get_ticks_usec()
	steine_Liste.append(stones.get_child(0).duplicate())
	#steine_Liste.append(stones.get_child(1).duplicate())
	#steine_Liste.append(stones.get_child(2).duplicate())
	#steine_Liste.append(stones.get_child(3).duplicate())
	#steine_Liste.append(stones.get_child(4).duplicate())
	#print(steine_Liste)
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if len(area2D.get_overlapping_bodies())==2 && !steine_Liste.is_empty() && !is_dragging && Time.get_ticks_usec() - time_delay > 200000:
		var stein = steine_Liste.pop_front()
		stein.scale = Vector2(0.5,0.5)
		var body = $"../../../../stones/test_ball".duplicate()
		var collision = $"../../../../stones/DefaultColission".duplicate()
		
		body.set_script(load("res://scripts/drag_drop_stones.gd"))
		stone_render.add_child(body)
		body.global_position = $spawnpoint.global_position
		body.add_child(stein)
		body.add_child(collision)
		
		
		stein.position = Vector2.ZERO
		collision.position =Vector2.ZERO
		time_delay = Time.get_ticks_usec()
	

	
	pass
