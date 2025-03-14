@tool
@icon("res://components/logic/icons/logic-purple.png")
class_name LogicTimer extends Logic
## Logic node that performs a for loop operation


# region Export
@export_group("Operator")
## The operator to use.
@export_enum("After", "Every", "For") var operator = "After";


@export_group("Variable")
## Amount of time to wait before executing the operation.
@export var variable_seconds: int = 5;


@export_group("Interation")
## The type of interaction to use.
@export_enum("string", "dropdown") var interaction_type = "string";
## The Dropdown options for the value if the interaction type is "dropdown".
@export var dropdown_options: Array[String] = [];
## Is the value interactable by the player?
@export var interactable: bool = false;
# endregion Export