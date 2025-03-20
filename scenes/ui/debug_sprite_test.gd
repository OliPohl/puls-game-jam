extends Sprite2D
var enabled = true:
  set(value):
    if (enabled != value):
      enabled = value
      if enabled:
        get_parent().get_parent().visible = value