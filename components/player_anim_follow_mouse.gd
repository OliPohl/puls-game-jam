extends AnimatedSprite2D

var _target : Vector2 = Vector2(130,205)

var _direction : bool  = false
func _input(_event):
    if _event is InputEventMouseButton:
        if _event.button_index == MOUSE_BUTTON_LEFT:
            _target = _event.position
            play("run")
            if position.x > _target.x:
                _direction = false
            else:
                _direction = true

func _process(_delta: float) -> void:
    if position.x != _target.x:
        position.x= move_toward(position.x,_target.x,  200*_delta)
        
        if _direction:
            flip_h = false
        else:
            flip_h  = true
    else:
        play("idle")