@icon("res://components/logic/icons/logic-blue.png")
class_name LogicBase extends Logic
## This is the base class for all logic nodes. It provides a common interface for all logic nodes to implement.

## Is the parent object interactable
@export var interactable: bool = true
@onready var parent: CanvasItem = get_parent()
var logic_used: int = 0

func _ready() -> void:
  confirm(true)

func show_logic() -> void:
  logic_ui.reset()
  logic_ui.title_node.text = parent.name + ".gd"
  for child in get_children():
    if child is Logic:
      child.create_ui()
  logic_ui.current_logic_base = self
  logic_ui.change_visibility(true)


func add_ui(_node: Node) -> void:
  logic_ui.add_logic_node(_node)


func confirm(_activate = true) -> void:
  logic_used += 1
  for child in get_children():
    if child is Logic:
      child.confirm(_activate)


func _process(_delta: float) -> void:
  pass
