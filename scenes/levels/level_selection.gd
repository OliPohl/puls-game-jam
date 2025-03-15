extends Node2D

func _ready() -> void:
    ## unlock levels
    var _level_settings = ConfigManager.load_level_settings()
	# _fullscreen_checkbutton.button_pressed = _video_settings.fullscreen
	# _vsync_checkbutton.button_pressed  =_video_settings.vsync
    var _highscore_settings = ConfigManager.load_highscore_settings()
	# _fullscreen_checkbutton.button_pressed = _video_settings.fullscreen
	# _vsync_checkbutton.button_pressed  =_video_settings.vsync