extends Node2D

@onready var righthand = $rightHand
@onready var lefthand = $leftHand
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _calculate_screen_center() -> Vector2:
	var transform : Transform2D = get_viewport_transform()
	var scale : Vector2 = transform.get_scale()
	return -transform.origin / scale + get_viewport_rect().size / scale / 2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if get_global_mouse_position().x < _calculate_screen_center().x:
		var mouse_pos: Vector2 = get_local_mouse_position()

		var texture_size: Vector2 = lefthand.texture.get_size() * scale
		var target_y: float = mouse_pos.y
		if texture_size.y != 0.0:
			var delta_x: float = mouse_pos.x - 0.0 # 0.0 because the left edge is at X=0
			var skew_angle: float = atan2(delta_x, texture_size.y)
			lefthand.skew = skew_angle
		print("left")
	else:
		print("right")
	pass
