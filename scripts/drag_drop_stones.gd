extends RigidBody2D

var is_dragging: bool = false

func _ready() -> void:
	# Ensure input pickable is true via code just in case
	input_pickable = true

func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	# Detect left mouse button click down on the object
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			start_dragging()

func _input(event: InputEvent) -> void:
	# Detect when the mouse button is released anywhere on the screen
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if not event.pressed and is_dragging:
			stop_dragging()

func _physics_process(_delta: float) -> void:
	# Smoothly move the object to the mouse position while dragging
	if is_dragging:
		global_position = get_global_mouse_position()

func start_dragging() -> void:
	is_dragging = true
	# Freeze linear and angular velocity so it doesn't carry old momentum
	linear_velocity = Vector2.ZERO
	angular_velocity = 0.0
	# Switch mode to Kinematic so physics doesn't fight our direct movements
	freeze = true
	freeze_mode = FREEZE_MODE_KINEMATIC

func stop_dragging() -> void:
	is_dragging = false
	# Unfreeze to let it drop and react to gravity/collisions naturally again
	freeze = false
