extends CharacterBody2D
class_name Enemy02

@onready var _player_visuals  :Node2D =$Visuals
@onready var _cooldown_timer : Timer = $CD_Timer
@onready var _sprite : AnimatedSprite2D =$Visuals/AnimatedSprite2D
@onready var _weapon : Node2D =$weapon
@onready var _hurtbox : Area2D =$HurtBox_Component
@onready var _playerhitbox : Area2D =$Player_HitBox
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
var _is_death : bool = false
func _ready() -> void:
    _cooldown_timer.timeout.connect(_on_cdtimer_timeout)    
    _hurtbox.area_entered.connect(_on_bullet_hit_self)
func _physics_process(_delta: float) -> void:
    if _is_death:
        return
    if _is_enemy_on_cooldown:
        return
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
    if _is_player_inrange and !_is_enemy_on_cooldown:
        _is_enemy_on_cooldown =true
        shoot()

func shoot()->void:
    _cooldown_timer.start()
    ### DIRECTION
    _weapon.shoot(_move_dir)
    _weapon.z_index +=5
    ### WAFFE Z _INDEX
func _on_cdtimer_timeout() ->void:
    _is_enemy_on_cooldown =false
    _weapon.z_index -=5
    ## z-index back

func _on_body_entered(_body : Node):
    if !_is_death:
        _sprite.play("idle")
        _is_player_inrange =true

func _on_body_exited(_body : Node):
    if !_is_death:
        _sprite.play("walking")
        _is_player_inrange = false

func _on_bullet_hit_self(_body: Area2D):
    print("Get damage")
    _sprite.play("dying")
    _is_death =true
    _playerhitbox.visible =false
    _playerhitbox.monitorable = false
    _playerhitbox.monitoring = false