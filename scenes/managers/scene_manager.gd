extends Node

const GAME_LEVEL_SELECTION : String ="res://scenes/levels/level_selection.tscn"
const GAME_LEVEL_01 : String = "res://scenes/levels/level_01.tscn"

var _game_level_list : Array[String]
var _current_scene : Node2D

func _ready() -> void:
    _game_level_list.append(GAME_LEVEL_SELECTION)
    _game_level_list.append(GAME_LEVEL_01)
    ### PRELOAD SCENES 
    for x in _game_level_list:
        ResourceLoader.load_threaded_request(x,"PackedScene",true)

func on_load_scene(_value :int) -> void:
    ## Remove scene to backgroun
    get_tree().root.remove_child(_current_scene)
    ##set Loaded Resource to PackedScene
    var _scene = ResourceLoader.load_threaded_get(_game_level_list[_value])
    ## Instantiate Scene
    _current_scene = _scene.instantiate()
    ## add to root
    get_tree().root.add_child(_current_scene)