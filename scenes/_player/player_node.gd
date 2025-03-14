extends CharacterBody2D
class_name Player_Node
@onready var _player_visuals : Sprite2D =$Visuals_Sprite
@onready var _player_coyote_timer:  Timer  =$Coyote_Timer
@onready var _jump_buffered_timer : Timer  =$Jump_buffered_Timer

#### DEBUG OBJECTS
@export var _position_label : Label
@export var _input_label : Label
### Global Variables, can be changed by Object Manager
var player_speed : float = 350
var player_gravity : float  = 33
var player_size : float  = 1
var player_coyote_time : float = 0.23
var player_jump_power : float  =800
var player_collision_layer : int  = 0
var player_Jump_enabled : bool  = true
var player_enabled : bool =  true
var player_died : bool  = false
### Privates 
var _move_dir : float = 0
var _looks_left : bool  = true
var _was_on_floor : bool  = true
var _can_still_jump :bool  = true
var _jump_buffered :bool = false
##debug
var _pos_string : String = "x: %s2, y:%s2"
### Ready connect signal to coyote timer
func _ready() -> void:
    _player_coyote_timer.timeout.connect(_on_coyote_timer_timeout)
    _jump_buffered_timer.timeout.connect(_on_jumped_buffered_timer_timeout)
    _player_coyote_timer.wait_time = player_coyote_time
######### INPUT
func _input(event: InputEvent) -> void:
    if event.is_action_pressed("left"):
        _looks_left = true
        _player_visuals.flip_h = _looks_left
    ## on release stop moving
    if event.is_action_pressed("right"):
        _looks_left = false
        _player_visuals.flip_h = _looks_left
    ## jump mechanic
    if event.is_action_pressed("jump"):
        _jump()

### Main Process
func _physics_process(_delta: float) -> void:
    if player_died:
        return
    _handle_gravity()
    if !player_enabled:
        return
    _handle_movement()
    _was_on_floor = is_on_floor()
    move_and_slide()
    _handle_coyote_time()
    _position_label.text = _pos_string % [position.x, position.y]
    

func _handle_gravity()-> void:
    if !is_on_floor() and !_can_still_jump:
        velocity.y += player_gravity

func _handle_movement() -> void:
    _move_dir = Input.get_axis("left","right")
    velocity.x  = player_speed * _move_dir

func _jump():
    if !player_Jump_enabled:
        return
    if is_on_floor() or _can_still_jump:
        velocity.y = -player_jump_power
        if _can_still_jump:
            _can_still_jump = false
    else:
        if !_jump_buffered:
            _jump_buffered = true
            _jump_buffered_timer.start()
## Start to fall
func _handle_coyote_time() -> void:
    if _was_on_floor and  !is_on_floor() and velocity.y >= 0:
        _can_still_jump = true
        _input_label.text = "CAN STILL JUMP"
        _player_coyote_timer.start()
    ## Touched ground
    if !_was_on_floor and is_on_floor():
        if _jump_buffered:
            _jump_buffered  =false
            _jump()

### function for timertimeout on coyote time
func _on_coyote_timer_timeout() -> void:
    _can_still_jump = false
    _input_label.text = ""
### function for timertimeout on buffered jump
func _on_jumped_buffered_timer_timeout()-> void:
    _jump_buffered = false

func on_collision_layer_change(_value : int) -> void:
    set_collision_mask_value(player_collision_layer, false)
    player_collision_layer = _value
    set_collision_mask_value(player_collision_layer, true)

func on_death()-> void:
    player_died = true
    # Animation
    # respawn