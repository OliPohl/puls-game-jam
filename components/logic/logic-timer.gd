@icon("res://components/logic/icons/logic-purple.png")
class_name LogicTimer extends Logic
## Logic node that performs a for loop operation


# region Export
@export_group("Operator")
## The operator to use.
@export_enum("After", "Every") var operator = "After";


@export_group("Variable")
## Amount of time to wait before executing the operation.
@export var variable_seconds: String = "5";


@export_group("Interation")
# ## The type of interaction to use.
# @export_enum("string", "dropdown") var interaction_type = "string";
# ## The Dropdown options for the value if the interaction type is "dropdown".
# @export var dropdown_options: Array[String] = [];
## Is the value interactable by the player?
@export var interactable: bool = false;
# endregion Export

var timer = 0
var start = false


func create_ui() -> void:
  ui_element = logic_ui.create_logic_timer_ui(operator, variable_seconds, interactable)

  var parent = get_parent() as Logic
  parent.add_ui(ui_element)

  for child in get_children():
    if child is Logic:
      child.create_ui()


func add_ui(_node: Node) -> void:
  var _ui_element = ui_element as LogicTimerUi
  _ui_element.add_then_node(_node)


func confirm(_activate : bool) -> void:
  if ui_element:
    var _ui_element = ui_element as LogicTimerUi
    variable_seconds = _ui_element.variable_seconds
  start = _activate
  if not _activate:
    for child in get_children():
      if child is Logic:
        child.confirm(false)


func _process(_delta: float) -> void:
  if not start:
    return

  timer += _delta
  if timer >= float(variable_seconds):
    for child in get_children():
      if child is Logic:
        child.confirm(true)
    timer = 0

  if operator == "After":
    start = false