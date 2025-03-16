extends Control
@onready var _slider_time : Slider =$Content_Margin/Setting_Margin/VBoxContainer/Setting_P/VBox/time_slider
@onready var _slider_object : Slider =$Content_Margin/Setting_Margin/VBoxContainer/Setting_P/VBox/used_objects_silder
@onready var _slider_death : Slider  =$Content_Margin/Setting_Margin/VBoxContainer/Setting_P/VBox/death_count_slider

@export var _time_label : Label
@export var _object_label : Label
@export var _death_label : Label

func set_sliders() -> void:
    var _time_max : float = GameManager.current_level * 10
    _slider_time.set_value_no_signal(GameManager.gameresult_time / _time_max)
    _slider_object.set_value_no_signal(float(GameManager.gameresult_objects)/10)
    _slider_death.set_value_no_signal(1 - (GameManager.gameresult_deaths * 0.33))
    ### set Labels
    _time_label.text = str(GameManager.gameresult_time)
    _object_label.text = str(GameManager.gameresult_objects)
    _death_label.text = str(GameManager.gameresult_deaths)
    ### LEVEL UNLOCK SAVE TO CONFIG FILE
    ConfigManager.save_level_settings("level_0"+ str(GameManager.current_level), true)
    #### DATA SAVE TO CONFIG FILE
    var _result : float  = (GameManager.gameresult_time*100) + (GameManager.gameresult_objects * 10) - (GameManager.gameresult_deaths*10)
    ConfigManager.save_highscore_settings("highscore_0"+ str(GameManager.current_level),_result)

     ### RESET VARIABLES 
    GameManager.reset_gameresults()
