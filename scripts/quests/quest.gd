# Waypoint.gd
@tool
class_name Quest
extends Resource

@export var name: String
@export var description: String
@export var duration: int
@export var rewards: Array[QuestReward]
