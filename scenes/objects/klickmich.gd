extends Sprite2D

var color : String = "white":
	set(value):
		if (color != value):
			color = value
			modulate = Color(value)