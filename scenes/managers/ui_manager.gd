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
@onready var _credit_control : Control = $Menu/Content_Margin/Credits_Margin
#timer
@onready var _game_timer :Timer  =$Game_Timer
@onready var _game_timer_text : Label  = %Timer_value
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
### pause panel
@onready var _pause_panel : ColorRect = $Pause_rect
###Privates 
var _is_timer_running : bool  = false
var _is_debug_running : bool = true
var _level_started_time : float = 0
func _ready() -> void:
	_game_timer.timeout.connect(_on_gametimer_timeout)
	GameManager.game_win.connect(_on_game_win)
	GameManager.game_over.connect(_on_game_over)
	## on paused
	GameManager.game_paused.connect(_on_game_paused)

	_debug_timer.timeout.connect(_debug_data_update)
	_debug_timer.start()
	### LOAD SETTINGS AND SET UI 
	var _video_settings = ConfigManager.load_video_settings()
	_fullscreen_checkbutton.button_pressed = _video_settings.fullscreen
	_vsync_checkbutton.button_pressed  =_video_settings.vsync
	var _audio_settings = ConfigManager.load_audio_setting()

	_master_v_slider.set_value_no_signal(_audio_settings.master_volume)
	AudioManager.on_master_volume(_audio_settings.master_volume)
	_sound_v_slider.set_value_no_signal(_audio_settings.sound_volume)
	AudioManager.on_sfx_volume(_audio_settings.sound_volume)
	_music_v_slider.set_value_no_signal(_audio_settings.music_volume)
	AudioManager.on_music_volume(_audio_settings.music_volume)

################### INPUT
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"):
		get_tree().paused = !get_tree().paused
		_pause_panel.visible = !_pause_panel.visible
	if event.is_action_pressed("restart"):
		start_menu()
		GameManager.start_level(GameManager.current_level)
###############################

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
		##### SAVE TIMESTEP 
		_level_started_time = Time.get_ticks_msec()
		_is_timer_running =true

#########################  GOTO MENU FUNCTION
func start_menu() ->void:
	_game_hud.visible= false
	_menu.visible =true
	_win_control.visible =false
	_game_over_control.visible = false
	_game_timer.stop()
func interact_paused_game() -> void :
	_game_timer.stop()
	_game_hud.visible= false
	_menu.visible =false
	_win_control.visible =false
	_game_over_control.visible = false
func interact_resume_game() -> void :
	_game_timer.start()
	_game_hud.visible= true
	_menu.visible =false
	_win_control.visible =false
	_game_over_control.visible = false
func start_level_selection() -> void:
	_game_hud.visible= true
	_menu.visible =false
	_win_control.visible =false
	_game_over_control.visible = false
	_game_timer.stop()
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
	### Death Counter ++
	GameManager.gameresult_deaths += 1
	_game_timer.stop()
	_win_control.visible =false
	_game_over_control.visible = true
	AudioManager.play_sound(AudioManager.Sound.LOSE)
	_game_hud.visible= false
	_menu.visible =false

#### cast from gamemanager Signal game_win
func _on_game_win() -> void:
	_game_timer.stop()
	_win_control.visible =true
	AudioManager.play_sound(AudioManager.Sound.WIN)
	_game_over_control.visible = false
	_game_hud.visible= false
	_menu.visible =false
	#### SET GAMERESULT_LEVEL_TIME
	GameManager.gameresult_time= Time.get_ticks_msec() - _level_started_time
	_win_control.set_sliders()

func _on_fullscreen_toggle_toggled(_toggled_on:bool) -> void:
	AudioManager.play_sound(AudioManager.Sound.CLICK)
	ConfigManager.save_video_settings("fullscreen", _toggled_on)
	## change to full screen


func _on_vsync_toggle_toggled(_toggled_on:bool) -> void:
	AudioManager.play_sound(AudioManager.Sound.CLICK)
	ConfigManager.save_video_settings("vsync",_toggled_on)
	## enable vsync


func _on_master_v_slider_drag_ended(value_changed:bool) -> void:
	if value_changed:
		AudioManager.play_sound(AudioManager.Sound.CLICK)
		AudioManager.on_master_volume(_master_v_slider.value)
		ConfigManager.save_audio_settings("master_volume", _master_v_slider.value)
		## change audio_manager bus volume

func _on_sound_v_silder_drag_ended(value_changed:bool) -> void:
	if value_changed:
		AudioManager.play_sound(AudioManager.Sound.CLICK)
		AudioManager.on_sfx_volume(_sound_v_slider.value)
		ConfigManager.save_audio_settings("sound_volume", _sound_v_slider.value)
		## change audio_manager bus volume

func _on_music_v_slider_drag_ended(value_changed:bool) -> void:
	if value_changed:
		AudioManager.play_sound(AudioManager.Sound.CLICK)
		AudioManager.on_music_volume(_music_v_slider.value)
		ConfigManager.save_audio_settings("music_volume", _music_v_slider.value)
		## change audio_manager bus volume
#############################################  MENU BUTTONS###############
func _on_button_start_pressed() -> void:
	AudioManager.play_sound(AudioManager.Sound.CLICK)
	GameManager.start_level(1)


func _on_button_resume_pressed() -> void:
	AudioManager.play_sound(AudioManager.Sound.CLICK)
	GameManager.change_game_state(GameManager.GameState.GAME_RUNNING)


func _on_button_settings_pressed() -> void:
	AudioManager.play_sound(AudioManager.Sound.CLICK)
	_setting_control.visible =  !_setting_control.visible
	_credit_control.visible  = false

func _on_button_credits_pressed() -> void:
	AudioManager.play_sound(AudioManager.Sound.CLICK)
	_credit_control.visible = !_credit_control.visible 
	_setting_control.visible =  false

func _on_button_select_lvl_pressed() -> void:
	AudioManager.play_sound(AudioManager.Sound.CLICK)
	_win_control.visible =false
	_game_over_control.visible = false
	_setting_control.visible = false
	GameManager.start_level(6)


func _on_button_quit_pressed() -> void:
	AudioManager.play_sound(AudioManager.Sound.CLICK)
	### SOUND SCHREI
	get_tree().quit()

####################################### MENU BUTTONS END ######################
############# WIN CONTROL BUTTONS##########
func _on_button_WIN_next_pressed() -> void:
	AudioManager.play_sound(AudioManager.Sound.CLICK)
	_win_control.visible =false
	_game_over_control.visible = false
	GameManager.reset_gameresults()
	GameManager.start_level(GameManager.current_level+1)
	
func _on_button_restart_pressed() -> void:
	AudioManager.play_sound(AudioManager.Sound.CLICK)
	start_menu()
	GameManager.start_level(GameManager.current_level)

func _on_button_menu_pressed() ->void:
	AudioManager.play_sound(AudioManager.Sound.CLICK)
	start_menu()
	GameManager.start_level(0)  ### Start Scene

func on_set_game_timer(_value : float) ->void:
	_game_timer.wait_time = _value
