extends Sprite2D

@onready var ref_quests = $quests
@onready var ref_quest = $"../quest"

@export var quests: Array[Quest] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
