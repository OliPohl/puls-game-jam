@tool
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
## The type of interaction to use.
@export_enum("string", "dropdown") var interaction_type = "string";
## The Dropdown options for the value if the interaction type is "dropdown".
@export var dropdown_options: Array[String] = [];
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