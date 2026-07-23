extends Sprite2D

@onready var ref_quests = $quests
@onready var ref_quest = $"../quest"
@onready var ref_quest_name = $"../quest/FoldableContainer"
@onready var ref_quest_duration = $"../quest/FoldableContainer/quest/HBoxContainer/HBoxContainer/Duration"
@onready var ref_quest_rewards = $"../quest/FoldableContainer/quest/HBoxContainer/HBoxContainer2"
@onready var ref_quest_stone = $"../Stone"

@export var quests: Array[Quest] = []:
	set(value):
		quests = value
		if ref_quests and ref_quest:
			render_quests()	
		
func render_quest(id: int, quest: Quest) -> PanelContainer:
	ref_quest_name.title = quest.name
	ref_quest_duration.text = str(quest.duration)
	# remove all children
	for child in ref_quest_rewards.get_children():
		child.free()
	
	# add rewards
	for reward in quest.rewards:
		var stone = ref_quest_stone.duplicate()
		stone.texture = reward.reward.image
		stone.visible = true
		ref_quest_rewards.add_child(stone)
	var clone = ref_quest.duplicate()
	clone.id = id
	clone.visible = true
	return clone
		
func render_quests():
	# remove old children
	for child in ref_quests.get_children():
		child.free()

	for i in range(len(quests)):
		ref_quests.add_child(render_quest(i, quests[i]))

func enter_quest(id: int):
	var quest = quests[id]
	print("entering quest", quest)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	render_quests()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
