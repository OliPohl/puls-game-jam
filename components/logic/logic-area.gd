@icon("res://components/logic/icons/logic-yellow.png")
class_name LogicArea extends Area2D
## Area node so that the object is interactable

var logic_ui: LogicUi = LogicUiNode
@onready var _parent = get_parent()
var logic_base: LogicBase
var _mouse_inside: bool = false


func _ready() -> void:
  _parent.material = logic_ui.interaction_mat
  _parent.use_parent_material = true

  for sibling in _parent.get_children():
    if sibling is LogicBase:
      logic_base = sibling
      break

  mouse_entered.connect(_on_area_mouse_entered)
  mouse_exited.connect(_on_area_mouse_exited)


func _on_area_mouse_entered() -> void:
  _parent.use_parent_material = false
  _mouse_inside = true


func _on_area_mouse_exited() -> void:
  _parent.use_parent_material = true
  _mouse_inside = false


func _unhandled_input(event: InputEvent) -> void:
  if not _mouse_inside:
    return

  if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
    logic_base.show_logic()