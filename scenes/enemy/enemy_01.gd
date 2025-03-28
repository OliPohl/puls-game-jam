extends CharacterBody2D
class_name Enemy01

@onready var _player_visuals  :Node2D =$Visuals

@onready var _sprite : AnimatedSprite2D =$Visuals/AnimatedSprite2D


############################################ EDITABLE VARIABLES
var color : String = "white":
    set(value):
        if (color != value):
            color = value
            _player_visuals.modulate = Color(value)

var enemy_size : float  = 1:
    set(value):
        if enemy_size != value:
            _player_visuals.scale = Vector2(value, value)
            enemy_size = value

var enemy_speed : float  = 200:
    set(value):
        if enemy_speed != value:
            enemy_speed = value
            _sprite.speed_scale =enemy_speed / 200
############################# PRIVATE

var _is_enemy_on_cooldown : bool = false
var _move_dir : float = -1
var _is_death : bool = false

func _physics_process(_delta: float) -> void:
    if _is_death:
        return
    if _is_enemy_on_cooldown:
        return

    _reverse_direction()
    _handle_walking(_delta)
    move_and_slide()

func _handle_walking(_delta : float) ->void:
   velocity.x = enemy_speed  *_move_dir

func _reverse_direction() ->void:
    if is_on_wall():
        _move_dir = -_move_dir
        _sprite.flip_h = !_sprite.flip_h
