extends AnimatedSprite2D
@export var button  : Button

func _ready() -> void:
    button.mouse_entered.connect(on_button_hover)
    button.mouse_exited.connect(on_button_default)
    button.pressed.connect(on_button_pressed)
func on_button_pressed():
    play("pressed")

func on_button_hover():
    play("hover")
func on_button_default():
    play("default")