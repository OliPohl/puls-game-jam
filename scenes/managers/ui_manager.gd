extends CanvasLayer
####################################################################
###
###               IMPORTANT GAME TIMER IS HERE AND TRIGGER GAME_OVER SIGNAL
###
###
#####################################################################
@onready var _game_hud : Control = $Game_HUD
@onready var _menu : Control = $Menu
## SETTINGS
@onready var _setting_control : Control = $Menu/Content_Margin/Setting_Margin
## CREDITS

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
### Win panel
@onready var _win_control : Control  =$Win_Control
### Game over panel
@onready var _game_over_control : Control =$Game_Over_Control
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
func _on_game_in_level_selection() -> void:
	_game_hud.visible= false
	_menu.visible =false
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
	var _minutes = _float /60
	var _seconds = fmod(_float, 60)
	var  _milliseconds = fmod(_float, 1) * 100
	var _text = "%02d:%02d:%02d" % [_minutes, _seconds, _milliseconds]
	return _text
### set game hud on and menu off and toggle 
func set_game_hud(_value : bool) ->void :
	_game_hud.visible= (_value)
	_menu.visible =(!_value)
	if _value:
		_win_control.visible =false
		_game_over_control.visible = false
		_game_timer.stop()
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
	_game_timer.stop()
	_win_control.visible =false
	_game_over_control.visible = true
	_game_hud.visible= false
	_menu.visible =false

func _on_game_win() -> void:
	_game_timer.stop()
	_win_control.visible =true
	_game_over_control.visible = false
	_game_hud.visible= false
	_menu.visible =false
	_win_control.set_sliders()


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
#############################################  MENU BUTTONS###############
func _on_button_start_pressed() -> void:
	GameManager.start_level(1)


func _on_button_resume_pressed() -> void:
	GameManager.change_game_state(GameManager.GameState.GAME_RUNNING)


func _on_button_settings_pressed() -> void:
	_setting_control.visible =  !_setting_control.visible


func _on_button_select_lvl_pressed() -> void:
	_win_control.visible =false
	_game_over_control.visible = false
	_setting_control.visible = false
	GameManager.start_level(6)


func _on_button_quit_pressed() -> void:
	### SOUND SCHREI
	get_tree().quit()

####################################### MENU BUTTONS END ######################
############# WIN CONTROL BUTTONS##########
func _on_button_WIN_next_pressed() -> void:
	_win_control.visible =false
	_game_over_control.visible = false
	GameManager.start_level(GameManager.current_level+1)
	
func _on_button_restart_pressed() -> void:
	_win_control.visible =false
	_game_over_control.visible = false
	GameManager.start_level(GameManager.current_level)

func _on_button_menu_pressed() ->void:
	_win_control.visible =false
	_game_over_control.visible = false
	GameManager.start_level(0)  ### Start Scene