@tool
@icon("res://components/logic/icons/logic-gray.png")
class_name Logic extends Node
## Abstract Logic class for creating custom logic nodes.


# region Utils
# Cast the value to the correct type.
func type_cast(type:String, value: String) -> Variant:
  match type:
    "int" : return int(value)
    "float" : return float(value)
    "bool" : return value == "true"
    "string" : return value
  return value


# Parse the variable name.
func parse_variable_name(value: String) -> String:
  return value.split(".")[-1]
# endregion Utils