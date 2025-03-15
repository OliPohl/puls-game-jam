class_name LogicUi extends CanvasLayer
## This script is the Ui Element for the Logic

## The Title Node that is shown to the player
@export var title_node: Label
@export var cancel_button: Button
@export var confirm_button: Button

@export_group("Nodes")
## Parent Node for the logic nodes
@export var logic_holder: VBoxContainer
## Bottom Spacer of the logic holder
@export var logic_holder_bottom_spacer: Control
## A node that holds templates and temp logic nodes
@export var logic_template_holder: Node
@export var pause_shader: PauseShader


@export_group("Tempaltes")
## The Template Node for the LogicIf
@export var logic_if_ui_node: LogicIfUi
## The Template Node for the LogicOperation
@export var logic_operation_ui_node: LogicOperationUi
## The Template Node for the LogicTimer
@export var logic_timer_ui_node: LogicTimerUi


@export_group("Edit Themes")
@export var edit_bool: Theme
@export var edit_int: Theme
@export var edit_float: Theme
@export var edit_string: Theme
@export var edit_var: Theme

var i : int = 2


func _ready() -> void:
  cancel_button.pressed.connect(_on_cancel_button_pressed)
  confirm_button.pressed.connect(_on_confirm_button_pressed)


func _on_confirm_button_pressed() -> void:
  #TODO: Send confirmation to creator
  change_visibility(false)


func _on_cancel_button_pressed() -> void:
  change_visibility(false)



# Adds a logic node to the logic holder
func add_logic_node(node: Node) -> void:
  logic_holder.add_child(node)
  logic_holder.move_child(logic_holder_bottom_spacer, -1)


# Clears all the children from the logic holder
func reset() -> void:
  for child in logic_holder.get_children():
    if not child.name.begins_with("Spacer"):
      child.queue_free()


# Creates a new LogicIfUi
func create_logic_if_ui(var_name: String, condition: String, value_name: String, value_type: String, interactable:bool) -> LogicIfUi:
  var node = logic_if_ui_node.duplicate()
  var new_logic_if_ui = node as LogicIfUi

  new_logic_if_ui.set_deferred("var_name", var_name)
  new_logic_if_ui.set_deferred("condition", condition)
  new_logic_if_ui.set_deferred("value_name", value_name)
  new_logic_if_ui.set_deferred("value_type", value_type)
  new_logic_if_ui.set_deferred("interactable", interactable)
  
  new_logic_if_ui.set_deferred("visible", true)
  return new_logic_if_ui


# Creates a new LogicOperationUi
func create_logic_operation_ui(var_name: String, operator: String, value_name: String, value_type: String, interactable:bool) -> LogicOperationUi:
  var node = logic_operation_ui_node.duplicate()
  var new_logic_operation_ui = node as LogicOperationUi

  new_logic_operation_ui.set_deferred("var_name", var_name)
  new_logic_operation_ui.set_deferred("operator", operator)
  new_logic_operation_ui.set_deferred("value_name", value_name)
  new_logic_operation_ui.set_deferred("value_type", value_type)
  new_logic_operation_ui.set_deferred("interactable", interactable)

  new_logic_operation_ui.set_deferred("visible", true)
  print("Created Logic Operation")
  return new_logic_operation_ui


# Creates a new LogicTimerUi
func create_logic_timer_ui(var_name: String, value_name: String, interactable:bool) -> LogicTimerUi:
  var node = logic_timer_ui_node.duplicate()
  var new_logic_timer_ui = node as LogicTimerUi

  new_logic_timer_ui.set_deferred("var_name", var_name)
  new_logic_timer_ui.set_deferred("value_name", value_name)
  new_logic_timer_ui.set_deferred("interactable", interactable)
  
  new_logic_timer_ui.set_deferred("visible", true)
  return new_logic_timer_ui


func change_visibility(value :bool) -> void:
  if value:
    offset.y = 700.0
    visible = true
    var tween = get_tree().create_tween()
    tween.tween_property(self, "offset:y", 0, 0.2)
    pause_shader.change_visibility(true)
  else:
    offset.y = 0.0
    var tween = get_tree().create_tween()
    tween.tween_property(self, "offset:y", 700.0, 0.2)
    pause_shader.change_visibility(false)
    await tween.finished
    visible = false