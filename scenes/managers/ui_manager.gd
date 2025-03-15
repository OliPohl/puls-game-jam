extends CanvasLayer

@onready var _game_hud : Control = $Game_HUD
@onready var _menu : Control = $Menu
#timer
@onready var _game_timer :Timer  =$Game_Timer
@onready var _game_timer_text : Label  =$Game_HUD/Timer_Margin/Panel/VBoxContainer/Timer_value
###Privates 
var _is_timer_running : bool  = false
func _ready() -> void:
    _game_timer.timeout.connect(_on_gametimer_timeout)
    set_game_hud(true)
func _process(_delta: float) -> void:
    if _is_timer_running:
        var _format_text : String  = "00:00:0%.2f" %[_game_timer.time_left]
        _game_timer_text.text = _format_text


func set_game_hud(_value : bool) ->void :
    _game_hud.visible= (_value)
    _menu.visible =(!_value)
    if _value:
        _game_timer.start()
        _is_timer_running =true
    
func _on_gametimer_timeout() -> void:
    ##signal player death
    _is_timer_running = false
    print("Game over")