extends CheckButton
@export var epic_end_checkbox : CheckButton

func _ontoggle_changed (_value : bool) -> void :
    if _value:
        epic_end_checkbox.visible = true
        hide()