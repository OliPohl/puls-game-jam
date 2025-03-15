class_name PauseShader extends TextureRect

func change_visibility(value: bool) -> void:
  if value:
    modulate.a = 0
    var tween = get_tree().create_tween()
    tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
    tween.tween_property(self, "modulate:a", 1, 0.2)
  else:
    var tween = get_tree().create_tween()
    tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
    tween.tween_property(self, "modulate:a", 0, 0.2)
    await tween.finished