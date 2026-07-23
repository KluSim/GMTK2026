extends Node
		
class Extention:
	var time: int
	var money: int
	
class MoneyPerson:
	var in_dept_amount: int = 0
	var payback_in_days: int
	var extentions_left:Array[Extention]
	
	func _init(ida: int, pay_in_days: int, exts: Array[Extention]) -> void:
		in_dept_amount = ida
		extentions_left = exts
		payback_in_days = pay_in_days
		
static func offer(
	stone: StoneResource, 
	customer: CustomerResource, 
	reputation: float
) -> bool:
	var dist = customer.request.stone_distance(stone)
	dist = 1000
	var goodenough = dist < customer.picky
	if not goodenough:
		print("häää")
		return false
	print(stone.fancy, reputation)
	var prize = stone.fancy * reputation * max(min(-0.4*+1.5, 1),0.1)
	return prize

static func generate_customer() -> CustomerResource:
	var rng = RandomNumberGenerator.new()
	print(RequestResource.SColor.values().pick_random() as RequestResource.SColor)
	
	var colors: Array[RequestResource.SColor] = []
	for i in range(rng.randi_range(1, 2)):
		colors.append(RequestResource.SColor.values().pick_random())
	
	var surfaces: Array[StoneResource.Surface] = []
	for i in range(rng.randi_range(1, 2)):
		surfaces.append(StoneResource.Surface.values().pick_random())
	
	var shapes: Array[StoneResource.Shape] = []
	for i in range(rng.randi_range(1, 2)):
		shapes.append(StoneResource.Shape.values().pick_random())
	
	
	return CustomerResource.new(
		rng.randf_range(0.0, 1.0),
		rng.randf_range(0.0, 1.0),
		RequestResource.new(
			colors,
			RequestResource.Shiny.values().pick_random() as RequestResource.Shiny,
			surfaces,
			shapes,
			"Hey, nice store! One black stone please :)"
		)
	)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
