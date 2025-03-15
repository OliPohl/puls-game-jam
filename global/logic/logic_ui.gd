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
@export var background : Panel = null


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
@export var interaction_mat : ShaderMaterial

var current_logic_base : LogicBase = null
var current_focus: TextEdit = null
var animating: bool = false


func _ready() -> void:
  cancel_button.pressed.connect(_on_cancel_button_pressed)
  confirm_button.pressed.connect(_on_confirm_button_pressed)


func _on_confirm_button_pressed() -> void:
  if current_logic_base != null:
    current_logic_base.confirm()
    current_logic_base.show_logic()
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
    animating = true
    offset.y = 700.0
    visible = true
    var tween = get_tree().create_tween()
    tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
    tween.tween_property(self, "offset:y", 0, 0.2)
    pause_shader.change_visibility(true)
    get_tree().paused = true
    await tween.finished
    animating = false
  else:
    animating = true
    offset.y = 0.0
    var tween = get_tree().create_tween()
    tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
    tween.tween_property(self, "offset:y", 700.0, 0.2)
    pause_shader.change_visibility(false)
    await tween.finished
    get_tree().paused = false
    visible = false
    animating = false



func _input(event: InputEvent) -> void:
  if animating or not visible:
    return
  if event is InputEventKey and event.pressed:
    if event.keycode == KEY_ENTER:
      current_focus.release_focus()
    elif event.keycode == KEY_ESCAPE:
      change_visibility(false)
  if event is InputEventMouseButton and event.pressed:
    var mouse_pos = get_viewport().get_mouse_position()
    if not background.get_global_rect().has_point(mouse_pos):
      change_visibility(false)
    elif current_focus and current_focus.get_global_rect().has_point(mouse_pos):
      current_focus.release_focus()
