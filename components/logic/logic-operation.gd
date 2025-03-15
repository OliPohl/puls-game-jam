@tool
@icon("res://components/logic/icons/logic-green.png")
class_name LogicOperation extends Logic
## Logic node that performs a logical operation


# region Export
@export_group("Variable")
## The node that contains the script with the variable to check.
@export var variable_node: Node = null;
## The name of the variable to check. You may add a classname prefix to the variable name. Anything before the dot will be ignored.
@export var variable_name: String = "player_jump";


@export_group("Operation")
## The operation to perform.
@export_enum("=", "+", "-", "*", "/", "+=", "-=", "*=", "%") var operator = "=";


@export_group("Value")
## The value type to operate on the variable.
@export_enum("int", "float", "bool", "string") var value_type = "int";
## The value to operate on the variable.
@export var value_name: String = "2";


@export_group("Interation")
# ## The type of interaction to use.
# @export_enum("string", "dropdown") var interaction_type = "string";
# ## The Dropdown options for the value if the interaction type is "dropdown".
# @export var dropdown_options: Array[String] = [];
## Is the value interactable by the player?
@export var interactable: bool = false;
# endregion Export


# region Utils
# Perform the operation on the two values.
func operate(a: Variant, b: Variant, _operator: String) -> Variant:
  match _operator:
    "=" : return b
    "+" : return a + b
    "-" : return a - b
    "*" : return a * b
    "/" : return a / b
    "+=" : return a + b
    "-=" : return a - b
    "*=" : return a * b
    "%" : return a % b
  return a


func create_ui() -> void:
  ui_element = logic_ui.create_logic_operation_ui(variable_name, operator, value_name, value_type, interactable)
  var parent = get_parent() as Logic

  parent.add_ui(ui_element)
# endregion Utils