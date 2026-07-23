class_name CustomerResource
extends Resource

@export var chill: float #1.0 chill 0 locked in
@export var picky: float #1.0 knows what they want 0.0 dont give a fuk
@export var request: RequestResource

func _init(
	chill: float,
	picky: float,
	request: RequestResource
):
	self.chill = chill
	self.picky = picky
	self.request = request
