extends Panel
@export var nomal_theme: Theme
@export var focus_theme: Theme

func _ready() -> void:
  mouse_entered.connect(_on_focus_entered)
  mouse_exited.connect(_on_focus_exited)

func _on_focus_entered() -> void:
  theme = focus_theme

func _on_focus_exited() -> void:
  theme = nomal_theme