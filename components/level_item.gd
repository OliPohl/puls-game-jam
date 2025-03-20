extends MarginContainer
signal level_selected()

### references 
@onready var level_label : Label =$PanelContainer/VBoxContainer/Content_Margin/Setting_Margin/VBoxContainer/PanelContainer/level_Label
@onready var level_texture : TextureRect = $PanelContainer/VBoxContainer/Content_Margin/Setting_Margin/VBoxContainer/PanelContainer4/TextureRect
@onready var button : TextureButton = $PanelContainer/VBoxContainer/Content_Margin/Panel/TextureButton

@export var level_name : String
@export var level_id : int
@export var level_sprite : Texture2D

func is_enabled()-> void:
    button.visible  =true
    ConfigManager.save_level_settings("level_0" + str(level_id), true)

var _is_allready_pressed: bool = false

func _ready() -> void:
    # init variables
    _is_allready_pressed = false
    level_label.text = level_name
    level_texture.texture = level_sprite

func _pressed() -> void :
    print("Button Pressed")
    if !_is_allready_pressed:
        _is_allready_pressed = true
        level_selected.emit()
        GameManager.start_level(level_id)
        AudioManager.play_sound(AudioManager.Sound.CLICK)
        position.y = 25.0
        var tween = get_tree().create_tween()
        tween.tween_property(self, "position:y", 700.0, 0.2)
        await tween.finished
