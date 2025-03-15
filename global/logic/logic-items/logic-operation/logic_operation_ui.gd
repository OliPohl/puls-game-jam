class_name LogicOperationUi extends HBoxContainer
## This script is the Ui Element for the LogicOperation


## The Variable Node that is shown to the player
@export var var_node: TextEdit
## The Operator Node that is shown to the player
@export var operator_node: Label
## The Value Node that is shown to the player
@export var value_node: TextEdit


## The Variable Name exposed to the logic parent
var var_name = "":
  set(value):
    if (var_node.text != value):
      var_node.text = " " + value
      var_name = value
  get:
    return var_node.text

## The Operator exposed to the logic parent
var operator = "":
  set(value):
    if (operator_node.text != value):
      operator_node.text = value
      operator = value
  get:
    return operator_node.text

## The Value exposed to the logic parent
var value_name = "":
  set(value):
    if (value_node.text != value):
      value_node.text = value
      value_name = value
  get:
    return value_node.text

## The Value Type exposed to the logic parent
var value_type = "int":
  set(value):
    if (value_node.placeholder_text != value):
      value_node.placeholder_text = " " + value
      value_type = value
      match value:
        "int":
          value_node.theme = LogicUiNode.edit_int
        "float":
          value_node.theme = LogicUiNode.edit_float
        "string":
          value_node.theme = LogicUiNode.edit_string
        "bool":
          value_node.theme = LogicUiNode.edit_bool
  get:
    return value_node.placeholder_text

## If the value is interactable
@export var interactable: bool = true:
  set(value):
    if (value_node.editable != value):
      value_node.editable = value
      if value:
        value_node.focus_mode = Control.FOCUS_ALL
        value_node.mouse_default_cursor_shape = Control.CURSOR_IBEAM
      else:
        value_node.focus_mode = Control.FOCUS_NONE
        value_node.mouse_default_cursor_shape = Control.CURSOR_FORBIDDEN
      interactable = value
  get():
    return value_node.editable


# Connect the text_changed signal to the set function
func _ready() -> void:
  var_node.text_changed.connect(_on_var_node_text_changed)
  value_node.text_changed.connect(_on_value_node_text_changed)


func _on_var_node_text_changed() -> void:
  var_name = var_node.text

func _on_value_node_text_changed() -> void:
  value_name = value_node.text