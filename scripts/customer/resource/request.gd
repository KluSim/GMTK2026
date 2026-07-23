class_name RequestResource
extends Resource

enum Shiny{Yes, No, Both}
enum SColor{Blue, Red, Violett, Black, Grey, Green}
	
@export var color: Array[RequestResource.SColor]
@export var shiny: Shiny
@export var surface: Array[StoneResource.Surface]
@export var shape: Array[StoneResource.Shape]
@export var message: String

func _init(
	_color: Array[RequestResource.SColor],
	_shiny: Shiny,
	_surface: Array[StoneResource.Surface],
	_shape: Array[StoneResource.Shape],
	_message: String
):
	self.color = _color
	self.shiny = _shiny
	self.surface = _surface
	self.shape = _shape
	self.message = _message
	
func stone_distance(stone: StoneResource) -> float:
	var dist: float = 0
	
	# add shinyness score
	dist += 0.3 * (!shiny_check(self.shiny, stone.shiny) as int)
	
	# add shape score
	var shape_dist = 1.0
	for shape in self.shape:
		shape_dist *= shape_distance(shape, stone.shape)
	dist += 0.3 * shape_dist
	
	# add surface score
	var surface_dist = 1.0
	for surface in self.surface:
		surface_dist *= surface_distance(surface, stone.surface)
	dist += 0.3 * surface_dist
		
	# add color score
	var color_distances: Array[float] = []
	for color_req in self.color:
		var color_distance: float = 0.0
		for material in stone.materials:
			color_distance *= color_distance(get_stone_color(color_req), material.color)
		color_distances.append(color_distance)
	var lowest  = 10000
	for c in color_distances:
		if lowest > c:
			lowest = c
	dist += lowest
	return dist

static func get_stone_color(stonecolor: SColor) -> Color:
	if stonecolor == SColor.Blue:
		return Color(0.199, 0.391, 0.802, 1.0)
	elif stonecolor == SColor.Red:
		return Color(0.794, 0.23, 0.243, 1.0)
	elif stonecolor == SColor.Violett:
		return Color(0.682, 0.034, 0.505, 1.0)
	elif stonecolor == SColor.Black:
		return Color(0.111, 0.111, 0.111, 1.0)
	elif stonecolor == SColor.Green:
		return Color(0.262, 0.556, 0.326, 1.0)
	elif stonecolor == SColor.Grey:
		return Color(0.296, 0.299, 0.269, 1.0)
	else: return Color(0.987, 0.987, 0.987, 1.0)

# Converts an RGB color to CIELAB and calculates the CIE76 distance
static func get_cie76_distance(color_a: Color, color_b: Color) -> float:
	var lab_a = rgb_to_lab(color_a)
	var lab_b = rgb_to_lab(color_b)
	
	# CIE76 is the Euclidean distance in Lab space
	var d_l = lab_a[0] - lab_b[0]
	var d_a = lab_a[1] - lab_b[1]
	var d_b = lab_a[2] - lab_b[2]
	
	return sqrt(d_l * d_l + d_a * d_a + d_b * d_b)

# Helper: Converts Godot Color (sRGB) to CIELAB space
static func rgb_to_lab(color: Color) -> Array[float]:
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
	
static func shiny_check(request: Shiny, shiny: bool) -> bool:
	# check if shinyness matches
	if request == Shiny.Yes && !shiny:
		return false
	if request == Shiny.No && shiny:
		return false
	return true
	
static func shape_distance(s1: StoneResource.Shape, s2: StoneResource.Shape) -> float:
	if s1 == s2:
		return 0.0
	if s1 == StoneResource.Shape.Round and s2 == StoneResource.Shape.Irregular\
	or s1 == StoneResource.Shape.Irregular and s2 == StoneResource.Shape.Round\
	or s1 == StoneResource.Shape.Rect and s2 == StoneResource.Shape.Irregular\
	or s1 == StoneResource.Shape.Irregular and s2 == StoneResource.Shape.Rect:
		return 0.5
	return 1.0	
	
static func surface_distance(s1: StoneResource.Surface, s2: StoneResource.Surface) -> float:
	if s1 == s2:
		return 0.0
	if s1 == StoneResource.Surface.Smooth and s2 == StoneResource.Surface.Rough\
	or s1 == StoneResource.Surface.Rough and s2 == StoneResource.Surface.Smooth\
	or s1 == StoneResource.Surface.Rough and s2 == StoneResource.Surface.Spikey\
	or s1 == StoneResource.Surface.Spikey and s2 == StoneResource.Surface.Rough:
		return 0.5
	return 1.0	
	
# 0.0 means identical colors.
# 2.5 means the difference is clearly notable to the casual human eye.
const min_dist = 0.0
const max_dist = 2.5
static func color_distance(c1: Color, c2: Color) -> float:
	var raw = get_cie76_distance(c1, c2)
	# Remap the value linearly to a 0.0 - 1.0 scale and cap it
	var scaled = remap(raw, min_dist, max_dist, 0.0, 1.0)
	return scaled
