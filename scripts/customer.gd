extends Node2D

const Classes = preload("res://scripts/peopls.gd")
var customer_schedule = [
	[
		Classes.Customer.new(1.0, 0.3,Classes.DesireProps.new(Classes.StoneColor.Black,Classes.GlitzerDesire.IDC,     Classes.StoneShape.Rough), "Hey, nice store! One black stone please"),
		Classes.Customer.new(0.5, 0.3,Classes.DesireProps.new(Classes.StoneColor.Grey, Classes.GlitzerDesire.IDC,     Classes.StoneShape.Rough), "Hey, nice store! One black stone please"),
		Classes.Customer.new(0.3, 0.3,Classes.DesireProps.new(Classes.StoneColor.Grey, Classes.GlitzerDesire.IDC,     Classes.StoneShape.Smooth), "Hey, nice store! One black stone please"),
		Classes.Customer.new(0.5, 0.3,Classes.DesireProps.new(Classes.StoneColor.Black,Classes.GlitzerDesire.Glitzer, Classes.StoneShape.Rough), "Hey, nice store! One black stone please"),
		Classes.Customer.new(0.1, 0.3,Classes.DesireProps.new(Classes.StoneColor.Grey, Classes.GlitzerDesire.IDC,     Classes.StoneShape.Spikey), "Hey, nice store! One black stone please")
	]
]
var day = 0
var index = -1
var thiscustomer = null
var state = "COME"
var reputation = 1.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_next()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if state == "COME":
		$Path2D/PathFollow2D.progress_ratio+=0.01
		
	if $Path2D/PathFollow2D.progress_ratio >= 0.5:
		state = "HERE"
		spawn_speech()
		
	#func _input(event: InputEvent) -> void:
	#if event.as_text() == "SPACE":
	#	give_stone(Classes.StoneProps.new(Color(), ))
	
func spawn_next():
	index+=1
	if index >= len(customer_schedule[day]):
		day += 1
	thiscustomer = customer_schedule[day][index]
	$Path2D/PathFollow2D.progress_ratio = 0

func spawn_speech():
	$ColorRect.visible = true
	$ColorRect/Label.text = thiscustomer.wantsstring
	
func give_stone(stone: Classes.StoneProps):
	var resp:float = Classes.Funcs.offer(stone, thiscustomer, reputation)
	if resp is float:
		$ColorRect/Label.text = str(resp)
