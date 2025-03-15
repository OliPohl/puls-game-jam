extends AnimatedSprite2D

var height : float = 2.7:
  set(value):
    if (height != value):
      height = value
      scale.y = value


func _ready() -> void:
  height = scale.y


var width : float = 1.0:
  set(value):
    if (width != value):
      width = value
      scale.x = value