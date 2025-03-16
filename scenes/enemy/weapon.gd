extends Node2D
@onready var _spawn_pos :Marker2D = $Sprite2D/Marker2D
@onready var _anim : AnimationPlayer = $AnimationPlayer

var _bullet : PackedScene =preload("res://scenes/enemy/bullet.tscn")

func shoot(_direction : float) ->void:
    var _instance = _bullet.instantiate()
    add_child(_instance)
    _instance.position = _spawn_pos.position
    _instance.shoot(_direction)
    _anim.play("shoot")