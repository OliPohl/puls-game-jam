extends Node2D
@export var mother :MarginContainer 
var unlocked : bool = false:
    set (_value):
        if unlocked != _value:
            unlocked  = _value
            if unlocked:
                visible =!unlocked
                mother.is_enabled()