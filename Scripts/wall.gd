extends StaticBody2D

func _ready():
	$CollisionPolygon2D.polygon = $Polygon2D.polygon
	$Line2D.points = $Polygon2D.polygon