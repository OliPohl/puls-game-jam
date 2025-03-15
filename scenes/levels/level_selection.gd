extends Node2D

#### LOCKED IMAGES
@onready var _level_01_locked : TextureRect = $Level_button_Control/HBoxContainer/Level_Item/level1_locked
@onready var _level_02_locked : TextureRect = $Level_button_Control/HBoxContainer/Level_Item2/level2_locked
@onready var _level_03_locked : TextureRect = $Level_button_Control/HBoxContainer/Level_Item3/level3_locked
@onready var _level_04_locked : TextureRect = $Level_button_Control/HBoxContainer/Level_Item4/level4_locked
@onready var _level_05_locked  : TextureRect = $Level_button_Control/HBoxContainer/Level_Item5/level5_locked
###### LEVEL ITEMS for button signal 
@onready var _level_01_item : MarginContainer =$Level_button_Control/HBoxContainer/Level_Item
@onready var _level_02_item : MarginContainer =$Level_button_Control/HBoxContainer/Level_Item2
@onready var _level_03_item : MarginContainer = $Level_button_Control/HBoxContainer/Level_Item3
@onready var _level_04_item :  MarginContainer = $Level_button_Control/HBoxContainer/Level_Item4
@onready var _level_05_item : MarginContainer =$Level_button_Control/HBoxContainer/Level_Item5
### highscore labels
@onready var _level_01_highscore : Label = $Level_button_Control/HBoxContainer/Level_Item/level_01_highscore
@onready var _level_02_highscore : Label = $Level_button_Control/HBoxContainer/Level_Item2/level_02_highscore2
@onready var _level_03_highscore : Label = $Level_button_Control/HBoxContainer/Level_Item3/level_03_highscore3
@onready var _level_04_highscore : Label = $Level_button_Control/HBoxContainer/Level_Item4/level_04_highscore4
@onready var _level_05_highscore : Label = $Level_button_Control/HBoxContainer/Level_Item5/level_05_highscore5
### player
@onready var _player_node : AnimatedSprite2D =$Player_anim/AnimatedSprite2D
func _ready() -> void:
    GameManager.current_scene = self
    ## unlock levels
    var _level_settings = ConfigManager.load_level_setting()
    _level_01_locked.visible = !_level_settings.level_01
    _level_02_locked.visible = !_level_settings.level_02
    _level_03_locked.visible  = !_level_settings.level_03
    _level_04_locked.visible  = !_level_settings.level_04
    _level_05_locked.visible  = !_level_settings.level_05
## connect button signal
    _level_01_item.level_selected.connect(on_level_selected)
    _level_02_item.level_selected.connect(on_level_selected)
    _level_03_item.level_selected.connect(on_level_selected)
    _level_04_item.level_selected.connect(on_level_selected)
    _level_05_item.level_selected.connect(on_level_selected)

    var _highscore_settings = ConfigManager.load_highscore_setting()
    _level_01_highscore.text = _format_decimal_float(_highscore_settings.level_01)
    _level_02_highscore.text = _format_decimal_float(_highscore_settings.level_02)
    _level_03_highscore.text = _format_decimal_float(_highscore_settings.level_03)
    _level_04_highscore.text = _format_decimal_float(_highscore_settings.level_04)
    _level_05_highscore.text = _format_decimal_float(_highscore_settings.level_05)
    ## set new gamestate
    GameManager.change_game_state(GameManager.GameState.LEVEL_SELECTION)

func on_level_selected()-> void:
    #anim play thumbup
    _player_node.play("win")
    # transition
func _format_decimal_float(_float : float) ->String:
    var _minutes = _float /60
    var _seconds = fmod(_float, 60)
    var  _milliseconds = fmod(_float, 1) * 100
    var _text = "%02d:%02d:%02d" % [_minutes, _seconds, _milliseconds]
    return _text