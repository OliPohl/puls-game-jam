extends Area2D

@export var flag: Node
@export var color_changed : bool  = false
### ADD TO AREA ENTERED 
func _ready() -> void:
  area_entered.connect(on_collect_area_entered)
var player_is_nearby :bool  = false:
  set(value):
    if player_is_nearby != value:
      player_is_nearby = value

var goal_enabled = true:
  set(value):
    if (goal_enabled != value):
      goal_enabled = value
      monitoring = value
      monitorable = value


var color : Color = "green":
  set(value):
    if (color != value):
      color = value
      flag.modulate = Color(value)
      check_if_color_redish(Color(value))


func check_if_color_redish(_color: Color) -> void:
  if _color.r > 0.7 and _color.g < 0.4 and _color.b < 0.4:
    goal_enabled = true
    check_player_and_red()
  else:
    goal_enabled = false
func check_player_and_red()->void:
  if goal_enabled and player_is_nearby:
    AudioManager.play_sound(AudioManager.Sound.FLAG)
  GameManager.Win_Game()
func on_collect_area_entered(_area : Area2D)-> void:
  ### PLAYER ENTERED 
  if _area is Hurtbox_Component:
    ### is player
    player_is_nearby = true
    ### DEFAULT FLAG FUNCTION
    if !color_changed:
      AudioManager.play_sound(AudioManager.Sound.FLAG)
      GameManager.Win_Game()