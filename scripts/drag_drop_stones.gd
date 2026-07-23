extends RigidBody2D

var is_dragging = false
var click_offset = Vector2.ZERO
var stone_spawner


func _ready():
	# Allow mouse inputs to propagate to this physics object
	input_pickable = true
	stone_spawner = $"../../visuals/shop visuals/leftshelf/korb"

func _physics_process(_delta):
	if is_dragging:
		print("start dragging")
		
		# Smoothly move the object to the mouse pointer minus where you initially clicked it
		global_position = get_global_mouse_position() - click_offset

func _input_event(_viewport, event, _shape_idx):
	# Check if the player left-clicked directly on the collision shape
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			start_drag()
			get_child(0).z_index = 1
			stone_spawner.is_dragging = true
		else:
			stop_drag()
			get_child(0).z_index = -1
			stone_spawner.is_dragging = false

func _input(event):
	# Handles dropping the object if the mouse release happens outside the collision shape
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		if is_dragging:
			stop_drag()

func start_drag():
	is_dragging = true
	# Calculate where inside the object the player clicked so it doesn't "snap" its center to the cursor
	click_offset = get_global_mouse_position() - global_position
	
	# Pause standard gravity/collisions dynamics while keeping track of movement
	freeze = true
	freeze_mode = FREEZE_MODE_KINEMATIC
	
	# Optional: Reset linear/angular velocity so it doesn't retain old speed when let go
	linear_velocity = Vector2.ZERO
	angular_velocity = 0.0

func stop_drag():
	is_dragging = false
	# Hand control back over to the physics server
	freeze = false
