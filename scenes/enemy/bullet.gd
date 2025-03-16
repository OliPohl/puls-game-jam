extends Node2D
var _max_distance : float = 15000

var bullet_speed : float  = 5:
    set(value):
        if bullet_speed != value:
            bullet_speed = value

var direction : float  = -1:
    set(value):
        if direction != value:
            direction = value
            if direction < 0:
                $Sprite2D.flip_h =false
            else:
                $Sprite2D.flip_h = true

var _distance_start : Vector2

func shoot(_get_direction : float ) -> void:
    
    _distance_start = global_position

func _physics_process(_delta: float) -> void:

    position.x +=direction*bullet_speed
    if _distance_start.distance_to(global_position) > _max_distance:
        call_deferred("_free_unit")
        

func _free_unit()->void:
    queue_free()