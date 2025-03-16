extends AnimatedSprite2D

var height : float:
  set(value):
    # print("value: ", value)
    if (height != value):
      height = value
      scale.y = value
  get:
    return scale.y


func _ready() -> void:
  height = scale.y


var width : float = 1.0:
  set(value):
    if (width != value):
      width = value
      scale.x = value



var size : float:
  set(value):
    if (size != value):
      size = value
      scale = Vector2(value, value)