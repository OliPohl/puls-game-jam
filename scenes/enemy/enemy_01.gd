extends CharacterBody2D
class_name Enemy

@onready var _player_visuals  :Node2D =$Visuals
@onready var _cooldown_timer : Timer = $CD_Timer
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
var _is_player_inrange : bool = false
var _is_enemy_on_cooldown : bool = false
var _move_dir : float = -1

func _ready() -> void:
    _cooldown_timer.timeout.connect(_on_cdtimer_timeout)    

func _physics_process(_delta: float) -> void:

    _handle_looking()
    _reverse_direction()
    _handle_walking(_delta)
    move_and_slide()

func _handle_walking(_delta : float) ->void:
   velocity.x = enemy_speed  *_move_dir

func _reverse_direction() ->void:
    if is_on_wall():
        _move_dir = -_move_dir
        _sprite.flip_h = !_sprite.flip_h

func _handle_looking() -> void:
    if _is_player_inrange:
        _is_enemy_on_cooldown =true
        _cooldown_timer.start()
        shoot()

func shoot()->void:
    pass
func _on_cdtimer_timeout() ->void:
    _is_enemy_on_cooldown =false

func _on_body_entered(_body : Node):
    _is_player_inrange =true

func _on_body_exited(_body : Node):
    _is_player_inrange = false