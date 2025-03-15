extends AnimatedSprite2D

var kill_player_on_entry : bool = true


func _ready() -> void:
  for child in get_children():
    if child is Area2D:
      child.body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node) -> void:
  if body is Player_Node and kill_player_on_entry:
    body = body as Player_Node
    body.on_death()