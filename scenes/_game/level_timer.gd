extends Node

@export var time_left  :float = 60

var _level_timer : float  = 0 
# var _ispaused : bool = false
func _ready() -> void:
    _level_timer  =0
    UiManager.set_level_timer_start(time_left)

func _physics_process(delta: float) -> void:
        _level_timer -= delta
        UiManager.set_level_timer(_level_timer)
