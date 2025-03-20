extends Node2D

@export var debug_menu : Control 
var enabled = true:
  set(value):
    if (enabled != value):
      enabled = value
      UiManager._on_debug_enabled(false)