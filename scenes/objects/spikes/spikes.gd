extends AnimatedSprite2D

var kill_player_on_entry : bool = true
@export var follow_player : bool = true
@export var player: Player_Node


func _ready() -> void:
  for child in get_children():
    if child is Area2D:
      child.body_entered.connect(_on_body_entered)
  play("idle")
  blink()



func _on_body_entered(body: Node) -> void:
  if body is Player_Node and kill_player_on_entry:
    body = body as Player_Node
    body.on_death()



func blink() -> void:
  play("blink")
  await animation_finished
  play("idle")
  await get_tree().create_timer(randf_range(2, 5)).timeout
  blink()


func _process(_delta: float) -> void:#
  if player and follow_player:
    transform.origin.x = player.transform.origin.x