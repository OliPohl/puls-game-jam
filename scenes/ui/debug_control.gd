extends Control


var enabled = true:
  set(value):
    if (enabled != value):
      enabled = value
      visible = value