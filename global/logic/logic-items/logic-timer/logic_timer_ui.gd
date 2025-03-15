class_name LogicTimerUi extends VBoxContainer
# The Timer Node that is shown to the player


## The Variable Node that is shown to the player
@export var var_node: TextEdit
## The Value Node that is shown to the player
@export var value_node: TextEdit
## The Parent Node for the Then Nodes
@export var then_parent: VBoxContainer

## The Variable Name exposed to the logic parent
var var_name = "":
  set(value):
    if (var_node.text != value):
      var_node.text = " " + value
      var_name = value
  get:
    return var_node.text

## The Value exposed to the logic parent
var value_name = "":
  set(value):
    if (value_node.text != value):
      value_node.text = value
      value_name = value
  get:
    return value_node.text

## If the value is interactable
@export var interactable: bool = true:
  set(value):
    if (value_node.editable != value):
      value_node.editable = value
      interactable = value
      if value:
        value_node.focus_mode = Control.FOCUS_ALL
        value_node.mouse_default_cursor_shape = Control.CURSOR_IBEAM
      else:
        value_node.focus_mode = Control.FOCUS_NONE
        value_node.mouse_default_cursor_shape = Control.CURSOR_FORBIDDEN
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

# Adds a logic then to be added by the parent
func add_then_node(node : Node):
  then_parent.add_child(node)