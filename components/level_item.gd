extends MarginContainer
signal level_selected()

### references 
@onready var level_label : Label =$PanelContainer/VBoxContainer/Content_Margin/Setting_Margin/VBoxContainer/PanelContainer/level_Label
@onready var level_texture : TextureRect = $PanelContainer/VBoxContainer/Content_Margin/Setting_Margin/VBoxContainer/PanelContainer4/TextureRect
@onready var level_button : Button = $PanelContainer/VBoxContainer/Content_Margin/Setting_Margin/VBoxContainer/PanelContainer3/Button

@export var level_name : String
@export var level_id : int
@export var level_sprite : Texture2D
var _is_allready_pressed: bool = false
func _ready() -> void:
    # init variables
    _is_allready_pressed = false
    level_label.text = level_name
    level_texture.texture = level_sprite
    level_button.pressed.connect(on_button_pressed)

func on_button_pressed() -> void :
    if !_is_allready_pressed:
        _is_allready_pressed = true
        level_selected.emit()
        GameManager.start_level(level_id)
        ##CLICK_SOUND
        ##Animation