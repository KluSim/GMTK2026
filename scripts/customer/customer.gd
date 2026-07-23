extends Node2D

const Classes = preload("res://scripts/customer/peopls.gd")
#Array[Array[Customer]], day, nr customer, customer
var customer_schedule = [
	range(5).map(func(i): return Classes.generate_customer())
]

var day = 0
var index = -1
var customer: CustomerResource = null
var state = "COME"
var reputation = 1.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_next()
	pass # Replace with function body.

var waitnum = 0.0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if state == "COME":
		$Path2D/PathFollow2D.progress_ratio+=0.01
		
	if state == "COME" and $Path2D/PathFollow2D.progress_ratio >= 0.5:
		state = "HERE"
		spawn_speech()
		
	if state == "SAYBUY":
		waitnum += delta
		if waitnum >= 1.3:
			state = "LEAVING"
	
	if state == "LEAVING" and $Path2D/PathFollow2D.progress_ratio <= 0.95:
		$Path2D/PathFollow2D.progress_ratio+=0.01
		if $Path2D/PathFollow2D.progress_ratio >= 0.95:
			state = "GONE"
			$Path2D/PathFollow2D/Sprite2D.visible = false
			$ColorRect.visible = false
			waitnum = randf()*4 +2
	if state == "GONE":
		waitnum -= delta
		if waitnum <= 0.0: 
			spawn_next()
		
#TODO this is just mokup on when+how to call what
func _input(event: InputEvent) -> void:
	if event.as_text() == "Space":
		if state == "GONE":
			spawn_next()
		if state == "HERE":
			var sr = StoneResource.new()
			sr.fancy = 100
			give_stone(sr)
	
func spawn_next():
	index+=1
	if index >= len(customer_schedule[day]):
		day += 1
	customer = customer_schedule[day][index]
	$Path2D/PathFollow2D.progress_ratio = 0
	state = "COME"
	$Path2D/PathFollow2D/Sprite2D.visible = true

func spawn_speech():
	$ColorRect.visible = true
	$ColorRect/Label.text = customer.request.message
	
func give_stone(stone: StoneResource):
	var resp:float = Classes.offer(stone, customer, reputation)
	if resp > 0:
		$ColorRect/Label.text = str(resp) +" money"
	else:
		$ColorRect/Label.text = "du hurensohn"
	state = "SAYBUY"
	waitnum = 0.0
