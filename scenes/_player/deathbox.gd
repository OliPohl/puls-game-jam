extends Area2D


func _ready() -> void:
  body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node) -> void:
  if body is Player_Node:
    body = body as Player_Node
    body.on_death()