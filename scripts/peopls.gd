extends Node

enum StoneColor {Blue, Red, Violett, Black, Grey, Green}
func get_stone_color(stonecolor: StoneColor) -> Color:
	if stonecolor == StoneColor.Blue:
		return Color(0.199, 0.391, 0.802, 1.0)
	elif stonecolor == StoneColor.Red:
		return Color(0.794, 0.23, 0.243, 1.0)
	elif stonecolor == StoneColor.Violett:
		return Color(0.682, 0.034, 0.505, 1.0)
	elif stonecolor == StoneColor.Black:
		return Color(0.111, 0.111, 0.111, 1.0)
	elif stonecolor == StoneColor.Green:
		return Color(0.262, 0.556, 0.326, 1.0)
	elif stonecolor == StoneColor.Grey:
		return Color(0.296, 0.299, 0.269, 1.0)
	else: return Color(0.987, 0.987, 0.987, 1.0)

# Converts an RGB color to CIELAB and calculates the CIE76 distance
func get_cie76_distance(color_a: Color, color_b: Color) -> float:
	var lab_a = rgb_to_lab(color_a)
	var lab_b = rgb_to_lab(color_b)
	
	# CIE76 is the Euclidean distance in Lab space
	var d_l = lab_a[0] - lab_b[0]
	var d_a = lab_a[1] - lab_b[1]
	var d_b = lab_a[2] - lab_b[2]
	
	return sqrt(d_l * d_l + d_a * d_a + d_b * d_b)

# Helper: Converts Godot Color (sRGB) to CIELAB space
func rgb_to_lab(color: Color) -> Array[float]:
	# 1. Inverse Component Linearization (sRGB to Linear RGB)
	var r = color.r
	var g = color.g
	var b = color.b
	
	r = (r / 12.92) if (r <= 0.04045) else pow((r + 0.055) / 1.055, 2.4)
	g = (g / 12.92) if (g <= 0.04045) else pow((g + 0.055) / 1.055, 2.4)
	b = (b / 12.92) if (b <= 0.04045) else pow((b + 0.055) / 1.055, 2.4)
	
	# 2. Linear RGB to XYZ (using D65 illuminant matrix)
	var x = r * 0.4124564 + g * 0.3575761 + b * 0.1804375
	var y = r * 0.2126729 + g * 0.7151522 + b * 0.0721750
	var z = r * 0.0193339 + g * 0.1191920 + b * 0.9503041
	
	# 3. XYZ to CIELAB (Normalized by D65 reference white points)
	var x_n = x / 0.95047
	var y_n = y / 1.00000
	var z_n = z / 1.08883
	
	x_n = pow(x_n, 1.0 / 3.0) if (x_n > 0.008856) else (7.787 * x_n) + (16.0 / 116.0)
	y_n = pow(y_n, 1.0 / 3.0) if (y_n > 0.008856) else (7.787 * y_n) + (16.0 / 116.0)
	z_n = pow(z_n, 1.0 / 3.0) if (z_n > 0.008856) else (7.787 * z_n) + (16.0 / 116.0)
	
	var l = (116.0 * y_n) - 16.0
	var a = 500.0 * (x_n - y_n)
	var c = 200.0 * (y_n - z_n)
	
	return [l, a, c]

enum StoneShape{Smooth, Rough, Spikey}

enum GlitzerDesire{Glitzer, IDC, Dull}

class DesireProps:
	var color: StoneColor
	var glitzern: GlitzerDesire
	var shape: StoneShape
	func _init(col:StoneColor, glit: GlitzerDesire, shap: StoneShape) -> void:
		color = col
		glitzern = glit
		shape = shap

class StoneProps:
	var color: Dictionary[Color, float] = {}
	var glitzern: bool = false
	var shape: StoneShape
	var fancyness: float
	
	func _init(col, glit, sh, fancy):
		color = col
		glitzern = glit
		shape = sh
		fancyness = fancy

class Dist:
	var dist: float
	var reason: String
	
	func _init(d, r) -> void:
		dist = d
		reason = r

func stoneprop_dist(desire: DesireProps, stone: StoneProps) -> Dist:
	var dist = 0.0
	var resason = "shape"
	if desire.glitzern == GlitzerDesire.Glitzer and not stone.glitzern:
		return Dist.new(1.0, "glitz")
	elif desire.glitzern == GlitzerDesire.Dull and stone.glitzern:
		return Dist.new(1.0, "glitz")
		
	if desire.shape != stone.shape:
		if desire.shape == StoneShape.Smooth and stone.shape == StoneShape.Rough\
		or desire.shape == StoneShape.Rough and stone.shape == StoneShape.Smooth\
		or desire.shape == StoneShape.Rough and stone.shape == StoneShape.Spikey\
		or desire.shape == StoneShape.Spikey and stone.shape == StoneShape.Rough:
			dist += 0.2
		
		else:
			dist += 0.6
		
	var coldist = 0.0
	for col in stone.color:
		var weight = stone.color[col]
		var raw_distance = get_cie76_distance(get_stone_color(desire.color), col)
		# 0.0 means identical colors.
		# 2.5 means the difference is clearly notable to the casual human eye.
		var min_dist = 0.0
		var max_dist = 2.5
		# Remap the value linearly to a 0.0 - 1.0 scale and cap it
		var scaled_distance = remap(raw_distance, min_dist, max_dist, 0.0, 1.0)
		coldist += scaled_distance * weight
	if coldist >= 0.7:
		resason = "color"
	return Dist.new(dist + coldist, resason)

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
		
	
class Customer:
	var gelassenheit: float#1.0 chill 0 locked in
	var desireProps: DesireProps 
	var pickyness: float#1.0 knows what they want 0.0 dont give a fuk
	func _init(gela: float,  picky: float, desires: DesireProps) -> void:
		gelassenheit = gela
		desireProps = desires
		pickyness = picky

func offer(stone: StoneProps, customer: Customer, reputation: float):
	var dist = stoneprop_dist(customer.desireProps, stone)
	var goodenough = dist.dist < customer.pickyness
	if not goodenough:
		return [false, dist.reason]
	var prize = stone.fancyness * reputation * max(min(-0.4*dist.dist, 1),0)
	return prize

#Array[Array[Customer]], day, nr customer, customer
var customer_schedule = [
	[
		Customer.new(1.0, 0.3,DesireProps.new(StoneColor.Black, GlitzerDesire.IDC, StoneShape.Rough)),
		Customer.new(0.5, 0.3,DesireProps.new(StoneColor.Grey, GlitzerDesire.IDC, StoneShape.Rough)),
		Customer.new(0.3, 0.3,DesireProps.new(StoneColor.Grey, GlitzerDesire.IDC, StoneShape.Smooth)),
		Customer.new(0.5, 0.3,DesireProps.new(StoneColor.Black, GlitzerDesire.Glitzer, StoneShape.Rough)),
		Customer.new(0.1, 0.3,DesireProps.new(StoneColor.Grey, GlitzerDesire.IDC, StoneShape.Spikey))
	]
]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
