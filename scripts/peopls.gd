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
		
func offer(
	stone: StoneResource, 
	customer: CustomerResource, 
	reputation: float
) -> bool:
	var dist = customer.request.stone_distance(stone)
	var goodenough = dist < customer.pickyness
	if not goodenough:
		return false
	var prize = stone.fancy * reputation * max(min(-0.4*dist.dist, 1),0)
	return prize

var rng = RandomNumberGenerator.new()
func generate_customer() -> CustomerResource:
	return CustomerResource.new(
		rng.randf_range(0.0, 1.0),
		rng.randf_range(0.0, 1.0),
		RequestResource.new(
			range(rng.randi_range(0, 2)).map(func(i): RequestResource.SColor.values().pick_random()),
			RequestResource.Shiny.values().pick_random(),
			range(rng.randi_range(0, 2)).map(func(i): StoneResource.Surface.values().pick_random()),
			range(rng.randi_range(0, 2)).map(func(i): StoneResource.Shape.values().pick_random())
		)
	)
	
#Array[Array[Customer]], day, nr customer, customer
var customer_schedule = [
	range(5).map(func(i): generate_customer())
]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
