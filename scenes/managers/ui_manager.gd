extends CanvasLayer
####################################################################
###
###               IMPORTANT GAME TIMER IS HERE AND TRIGGER GAME_OVER SIGNAL
###
###
#####################################################################
@onready var _game_hud : Control = $Game_HUD
@onready var _menu : Control = $Menu
#timer
@onready var _game_timer :Timer  =$Game_Timer
@onready var _game_timer_text : Label  =$Game_HUD/Timer_Margin/Panel/VBoxContainer/Timer_value
### DEBUG VALUES
@onready var _debug_control :Control = $Debug_Control
@onready var _debug_on_value :Label =$Debug_Control/Debug_Margin/HBoxContainer/debug_values/debug_value
@onready var _debug_fps_value : Label = $Debug_Control/Debug_Margin/HBoxContainer/debug_values/frames_value
@onready var _debug_ram_value :Label = $Debug_Control/Debug_Margin/HBoxContainer/debug_values/ram_value
@onready var _debug_gpu_value  : Label  =$Debug_Control/Debug_Margin/HBoxContainer/debug_values/gpu_value
@onready var _debug_timer : Timer = $Debug_Control/Debug_Interval
### BUTTONS
@onready var _button_start : Button = $Menu/Menu_button_Margin/VBoxContainer/Button_Start
@onready var _button_resume: Button = $Menu/Menu_button_Margin/VBoxContainer/Button_Resume
### SLIDERS
@onready var _master_v_slider : Slider = $Menu/Content_Margin/Setting_Margin/VBoxContainer/Setting_P/VBox/master_v_slider
@onready var _sound_v_slider : Slider = $Menu/Content_Margin/Setting_Margin/VBoxContainer/Setting_P/VBox/sound_v_silder
@onready var _music_v_slider : Slider  =$Menu/Content_Margin/Setting_Margin/VBoxContainer/Setting_P/VBox/music_v_slider
### Checkboxes
@onready var _fullscreen_checkbutton : CheckButton =$Menu/Content_Margin/Setting_Margin/VBoxContainer/Setting_P/VBox/fullscreen_toggle
@onready var _vsync_checkbutton : CheckButton = $Menu/Content_Margin/Setting_Margin/VBoxContainer/Setting_P/VBox/vsync_toggle
###Privates 
var _is_timer_running : bool  = false
var _is_debug_running : bool = true
func _ready() -> void:
	_game_timer.timeout.connect(_on_gametimer_timeout)
	GameManager.game_win.connect(_on_game_win)
	GameManager.game_over.connect(_on_game_over)
	## on paused
	GameManager.game_paused.connect(_on_game_paused)

	_debug_timer.timeout.connect(_debug_data_update)
	set_game_hud(false)
	_debug_timer.start()
	### LOAD SETTINGS AND SET UI 
	var _video_settings = ConfigManager.load_video_settings()
	_fullscreen_checkbutton.button_pressed = _video_settings.fullscreen
	_vsync_checkbutton.button_pressed  =_video_settings.vsync
	var _audio_settings = ConfigManager.load_audio_setting()
	_master_v_slider.set_value_no_signal(_audio_settings.master_volume)
	_sound_v_slider.set_value_no_signal(_audio_settings.sound_volume)
	_music_v_slider.set_value_no_signal(_audio_settings.music_volume)

func _process(_delta: float) -> void:
	if _is_timer_running:
		_game_timer_text.text = _format_decimal_float(_game_timer.time_left)

### if game paused _resume button on and gamehud off and opposite ///
func _on_game_paused(_value : bool)->void:
	_button_change_paused(_value)
	set_game_hud(!_value)
### buttton resume and start  toggle<->
func _button_change_paused(_value :bool) ->void:
	_button_resume.visible = _value
	_button_start.visible = !_value
### format timer time
func _format_decimal_float(_float : float) ->String:
	var _format_text : String  = str(_float)
	var _decimal_index : int = _format_text.find(".")
	if _decimal_index >0:
		_format_text = _format_text.left(_decimal_index + 3)
	return _format_text
### set game hud on and menu off and toggle 
func set_game_hud(_value : bool) ->void :
	_game_hud.visible= (_value)
	_menu.visible =(!_value)
	if _value:
		_game_timer.start()
		_is_timer_running =true
### if gametimer timeout -> loos
func _on_gametimer_timeout() -> void:
	##signal player death
	_is_timer_running = false
	print("Game over")
	GameManager.change_game_state(GameManager.GameState.GAME_OVER)

func _on_debug_enabled(_value : bool)-> void:
	_is_debug_running = _value
	if _value:
		_debug_on_value.text = "On"
		_debug_control.visible = true
		_debug_timer.start()
	else:
		_debug_on_value.text = "Off"
		### wait 0.5 s 
		_debug_control.visible = false
		_debug_timer.stop()

func _debug_data_update() -> void:
	_debug_fps_value.text = str(Engine.get_frames_per_second())
	_debug_ram_value.text = str(randi_range(8,16)) + ","+ str(randi_range(0,9))+ "MB"
	_debug_gpu_value.text = "13," + str(randi_range(0,9))+ "°"

func _on_game_over() ->void:
	## show gameover panel 
	pass

func _on_game_win() -> void:
	## show gamewin panel
	pass


func _on_fullscreen_toggle_toggled(_toggled_on:bool) -> void:
	ConfigManager.save_video_settings("fullscreen", _toggled_on)
	## change to full screen


func _on_vsync_toggle_toggled(_toggled_on:bool) -> void:
	ConfigManager.save_video_settings("vsync",_toggled_on)
	## enable vsync


func _on_master_v_slider_drag_ended(value_changed:bool) -> void:
	if value_changed:
		ConfigManager.save_audio_settings("master_volume", _master_v_slider.value)
		## change audio_manager bus volume

func _on_sound_v_silder_drag_ended(value_changed:bool) -> void:
	if value_changed:
		ConfigManager.save_audio_settings("sound_volume", _sound_v_slider.value)
		## change audio_manager bus volume

func _on_music_v_slider_drag_ended(value_changed:bool) -> void:
	if value_changed:
		ConfigManager.save_audio_settings("music_volume", _music_v_slider.value)
		## change audio_manager bus volume