@tool
@icon("res://components/logic/icons/logic-blue.png")
class_name LogicBase extends Logic
## This is the base class for all logic nodes. It provides a common interface for all logic nodes to implement.



var children : Array = []

func _ready() -> void:
  logic_ui.reset()
  logic_ui.title_node.text = get_parent().name
  for child in get_children():
    if child is Logic:
      child.create_ui()

  logic_ui.change_visibility(true)
  print("LogicBase Ready")

func add_ui(_node: Node) -> void:
  logic_ui.add_logic_node(_node)