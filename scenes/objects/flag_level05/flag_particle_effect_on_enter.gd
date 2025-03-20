extends Area2D
@onready var _particles : CPUParticles2D = $CPUParticles2D

func _ready() -> void:
    area_entered.connect(_on_player_entered)
func _on_player_entered (_area: Area2D) -> void:
    _particles.emitting = true