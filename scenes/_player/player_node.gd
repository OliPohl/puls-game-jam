extends CharacterBody2D
class_name Player_Node
@export var _player_visuals : AnimatedSprite2D
@export var _use_coyote_time_light  : bool = false
@onready var _player_coyote_timer:  Timer  =$Coyote_Timer
@onready var _jump_buffered_timer : Timer  =$Jump_buffered_Timer
@onready var _collect_area : Area2D = $Hurt_Box_Component
@onready var _PointLight2D : PointLight2D =$PointLight2D
### particle system
@export var _particles : CPUParticles2D
### Global Variables, can be changed by Object Manager
var layer : int = 1:
	set(value):
		if layer != value:
			set_collision_mask_value(1, false)
			set_collision_mask_value(2, false)
			set_collision_mask_value(3, false)
			layer = value
			set_collision_mask_value(layer, true)

var position_y : float = 0
			

var player_speed : float = 350
var player_gravity : float  = 33
var player_size : float  = 1:
	set(value):
		if player_size != value:
			scale = Vector2(value, value)
			player_size = value
var player_coyote_time : float = 0.23:
	set(value):
		if player_coyote_time != value:
			_player_coyote_timer.wait_time = value
			player_coyote_time = value
var player_jump_power : float  = 800
var player_collision_layer : int  = 0
var player_Jump_enabled : bool  = true
var player_enabled : bool =  true
var player_died : bool  = false
### Privates 
var _move_dir : float = 0
var _looks_left : bool  = true
var _was_on_floor : bool  = false
var _can_still_jump :bool  = false
var _jump_buffered :bool = false


var color : String = "white":
	set(value):
		if (color != value):
			color = value
			_player_visuals.modulate = Color(value)

### Ready connect signal to coyote timer
func _ready() -> void:
	_player_coyote_timer.timeout.connect(_on_coyote_timer_timeout)
	_jump_buffered_timer.timeout.connect(_on_jumped_buffered_timer_timeout)
	_player_coyote_timer.wait_time = player_coyote_time
	_collect_area.area_entered.connect(on_collect_area_entered)
	
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
	if !player_enabled:
		return
	position_y = position.y
	if player_died:
		died()
	_handle_gravity()
	_handle_movement()
	_was_on_floor = is_on_floor()
	move_and_slide()
	_handle_coyote_time()    

func _handle_gravity()-> void:
	if !is_on_floor() and !_can_still_jump:
		velocity.y += player_gravity
		#Jump/Fall Animation
		if velocity.y < 0:
			_player_visuals.animation = "jump_up"
		else:
			_player_visuals.animation = "jump_down"

func _handle_movement() -> void:
	_move_dir = Input.get_axis("left","right")
	velocity.x  = player_speed * _move_dir
	if velocity.x != 0 and is_on_floor():
		_player_visuals.animation = "run"
	if velocity.x == 0 and is_on_floor():
		_player_visuals.animation = "idle"

func _jump():
	if !player_Jump_enabled:
		return
	if is_on_floor() or _can_still_jump:
		AudioManager.play_sound(AudioManager.Sound.HIT)
		_particles.emitting =true
		velocity.y = -player_jump_power
		if _can_still_jump:
			_can_still_jump = false
	else:
		if !_jump_buffered:
			_jump_buffered = true
			_jump_buffered_timer.start()
## Start to fall
func _handle_coyote_time() -> void:
	if _can_still_jump:
		if _player_coyote_timer.time_left < 0.5:
			if _use_coyote_time_light:
				_PointLight2D.enabled =true
	if _was_on_floor and  !is_on_floor() and velocity.y >= 0:
		_can_still_jump = true
		_player_coyote_timer.start()
	## Touched ground
	if !_was_on_floor and is_on_floor():
		if _jump_buffered:
			_jump_buffered  =false
			_jump()

### function for timertimeout on coyote time
func _on_coyote_timer_timeout() -> void:
	_can_still_jump = false
	_PointLight2D.enabled =false
### function for timertimeout on buffered jump
func _on_jumped_buffered_timer_timeout()-> void:
	_jump_buffered = false

func on_collision_layer_change(_value : int) -> void:
	set_collision_mask_value(player_collision_layer, false)
	player_collision_layer = _value
	set_collision_mask_value(player_collision_layer, true)

func on_death()-> void:
	AudioManager.play_sound(AudioManager.Sound.HIT)
	player_died = true

func died() -> void :
	# Animation
	_player_visuals.animation = "hit"
	# respawn
	player_enabled  =false
	GameManager.on_game_over()

func on_collect_area_entered(_area : Area2D)-> void:
	AudioManager.play_sound(AudioManager.Sound.FLAG)
	GameManager.Win_Game()
