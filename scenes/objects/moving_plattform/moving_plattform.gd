extends Node2D
@onready var _collision_node : CollisionShape2D =$Moving_plattform/CollisionShape2D
@onready var _visuals : Node2D = $Moving_plattform
@onready var _player_detect_zone : Area2D = $Moving_plattform/Player_detect_zone
@onready var _player_detect_zone_collision : CollisionShape2D = $Moving_plattform/Player_detect_zone/CollisionShape2D

var active = false

func _ready() -> void:
    _player_detect_zone.body_entered.connect(_on_body_entered)


func _on_body_entered(_body: Node) -> void:
  active = true
  has_moved = true


var collision: bool = false:
  set(value):
    if (collision != value):
      collision = value
      _collision_node.disabled = !value
      _player_detect_zone_collision.disabled = !value
      if value:
        modulate.a = 1
      else:
        modulate.a = 0.6

var size : float = 1.0:
  set(value):
    if (size != value):
      size = value
      _visuals.scale = Vector2(value, value)

var speed : float = 7.1:
  set(value):
    if (speed != value):
      speed = value


var has_moved = false

func _physics_process(_delta: float) -> void:
  if active:
    _visuals.position.x += speed
