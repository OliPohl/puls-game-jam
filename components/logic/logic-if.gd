@icon("res://components/logic/icons/logic-red.png")
class_name LogicIf extends Logic
## Logic node that performs a conditional check on the input value and returns a boolean output.


# region Export
@export_group("Variable")
## The node that contains the script with the variable to check.
@export var variable_node: Node = null;
# The name of the variable to check. You may add a classname prefix to the variable name. Anything before the dot will be ignored.
@export var variable_name: String = "player_jump";


@export_group("Comparison")
## The comparison operator to use.
@export_enum("==", "!=", ">", "<", ">=", "<=") var comparator = "==";


@export_group("Value")
## The value type to compare the variable against.
@export_enum("int", "float", "bool", "string") var value_type = "bool";
## The value to compare the variable against.
@export var value_name: String = "true";


@export_group("Interation")
# ## The type of interaction to use.
# @export_enum("string", "dropdown") var interaction_type = "string";
# ## The Dropdown options for the value if the interaction type is "dropdown".
# @export var dropdown_options: Array[String] = [];
## Is the value interactable by the player?
@export var interactable: bool = false;
# endregion Export


# region Utils
# Compare the two values.
func compare(a: Variant, b: Variant, _comparator: String) -> bool:
  match _comparator:
    "==" : return a == b
    "!=" : return a != b
    ">" : return a > b
    "<" : return a < b
    ">=" : return a >= b
    "<=" : return a <= b
  return false
# endregion Utils


func create_ui() -> void:
  ui_element = logic_ui.create_logic_if_ui(variable_name, comparator, value_name, value_type, interactable)

  var parent = get_parent() as Logic
  parent.add_ui(ui_element)

  for child in get_children():
    if child is Logic:
      child.create_ui()


func add_ui(_node: Node) -> void:
  var _ui_element = ui_element as LogicIfUi
  _ui_element.add_then_node(_node)


func confirm(_activate : bool) -> void:
  if ui_element:
    var _ui_element = ui_element as LogicIfUi
    value_name = _ui_element.value_name

  if compare(variable_node.get(variable_name), type_cast(value_type, value_name), comparator):
    for child in get_children():
      if child is Logic:
        child.confirm(true)
  else:
    for child in get_children():
      if child is Logic:
        child.confirm(false)


func _process(_delta: float) -> void:
  if compare(variable_node.get(variable_name), type_cast(value_type, value_name), comparator):
    for child in get_children():
      if child is Logic:
        child.confirm(true)