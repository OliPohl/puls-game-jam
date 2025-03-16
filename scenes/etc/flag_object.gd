extends Area2D

@export var script_enabled : bool = false
@export var flag: Node

var goal_enabled = false:
  set(value):
    if not script_enabled:
      return
    if (goal_enabled != value):
      goal_enabled = value
      monitoring = value
      monitorable = value
      color = "white"

var color : Color = "white":
  set(value):
    if not script_enabled:
      return
    if (color != value):
      color = value
      flag.modulate = Color(value)
      check_if_color_redish(Color(value))


func check_if_color_redish(_color: Color) -> void:
  if _color.r > 0.5 and _color.g < 0.5 and _color.b < 0.5:
    goal_enabled = true
  else:
    goal_enabled = false