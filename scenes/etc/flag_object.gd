extends Area2D

@export var flag: Node

var goal_enabled = true:
  set(value):
    if (goal_enabled != value):
      goal_enabled = value
      monitoring = value
      monitorable = value


var color : Color = "green":
  set(value):
    if (color != value):
      color = value
      flag.modulate = Color(value)
      check_if_color_redish(Color(value))


func check_if_color_redish(_color: Color) -> void:
  if _color.r > 0.7 and _color.g < 0.4 and _color.b < 0.4:
    goal_enabled = true
  else:
    goal_enabled = false