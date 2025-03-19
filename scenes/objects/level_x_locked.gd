extends Node2D

var unlocked : bool = false:
    set (_value):
        if unlocked != _value:
            unlocked  = _value
            if unlocked:
                get_parent().is_enabled = true
                visible =!unlocked