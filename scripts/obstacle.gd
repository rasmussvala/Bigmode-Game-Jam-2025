extends StaticBody2D

@onready var polygon_2d: Polygon2D = $Polygon2D
@onready var collision_polygon_2d: CollisionPolygon2D = $CollisionPolygon2D

func _ready():
	# make collision polygon match polygon shape
	collision_polygon_2d.polygon = polygon_2d.polygon
