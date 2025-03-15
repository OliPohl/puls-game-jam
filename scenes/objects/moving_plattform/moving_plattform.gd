extends StaticBody2D
@onready var _collision_node : CollisionShape2D =$Moving_plattform/CollisionShape2D
@onready var _visuals : Node2D = $Moving_plattform
@onready var _animation_player : AnimationPlayer = $AnimationPlayer
var collision: bool:
    set(value):
        if (collision != value):
            collision = value
            _collision_node.disabled = value

var size : float = 1.0:
  set(value):
    if (size != value):
      size = value
      _visuals.scale = Vector2(value, value)

var speed : float = 1.0:
  set(value):
    if (speed != value):
      speed = value
      _animation_player.speed_scale = value

