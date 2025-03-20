extends Control
@onready var _slider_time : Slider =$Content_Margin/VBox/HBoxContainer/time_slider
@onready var _slider_object : Slider =$Content_Margin/VBox/HBoxContainer2/used_objects_silder
@onready var _slider_death : Slider  =$Content_Margin/VBox/HBoxContainer3/death_count_slider

@onready var _time_label : Label =$Content_Margin/VBox/HBoxContainer/time_s_value
@onready var _object_label : Label = $Content_Margin/VBox/HBoxContainer2/used_objects_value
@onready var _death_label : Label =$Content_Margin/VBox/HBoxContainer3/death_count_value
@onready var _total_label : Label  =$Content_Margin/VBox/total_Label
func set_sliders() -> void:
    var _result_total :float = GameManager.gameresult_time * GameManager.gameresult_objects  * (100-GameManager.gameresult_deaths)
    
    _slider_time.set_value_no_signal(GameManager.gameresult_time)
    _slider_object.set_value_no_signal(float(GameManager.gameresult_objects))
    _slider_death.set_value_no_signal(3 - GameManager.gameresult_deaths)
    ### set Labels
    _time_label.text = str(int(GameManager.gameresult_time))
    _object_label.text = str(int(GameManager.gameresult_objects))
    _death_label.text = str(GameManager.gameresult_deaths)
    _total_label.text  = str(int(_result_total))
    ### LEVEL UNLOCK SAVE TO CONFIG FILE
    ConfigManager.save_level_settings("level_0"+ str(GameManager.current_level+1), true)
    #### DATA SAVE TO CONFIG FILE
    ConfigManager.save_highscore_settings("highscore_0"+ str(GameManager.current_level),_result_total)
    ### RESET VARIABLES 
    GameManager.reset_gameresults()
