extends Node
class_name Scene_Manager
const GAME_LEVEL_SELECTION : String ="res://scenes/_game/level_selection.tscn"
const GAME_LEVEL_01 : String = "res://scenes/_game/level1.tscn"
const GAME_LEVEL_02 : String = "res://scenes/_game/level2.tscn"
const GAME_LEVEL_03 : String = "res://scenes/_game/level3.tscn"
const GAME_LEVEL_04 : String = "res://scenes/_game/level4.tscn"
const GAME_LEVEL_05 : String = "res://scenes/_game/level5.tscn"
const GAME_LEVEL_MENU : String = "res://scenes/_game/main_menu.tscn"
### PRIVATES
var _level_00
var _level_01
var _level_02
var _level_03
var _level_04
var _level_05
var _level_06
var current_scene
func _ready() -> void:
    # Load all level scene.
    _level_00 = ResourceLoader.load(GAME_LEVEL_MENU)
    _level_01 = ResourceLoader.load(GAME_LEVEL_01)
    _level_02 = ResourceLoader.load(GAME_LEVEL_02)
    _level_03 = ResourceLoader.load(GAME_LEVEL_03)
    _level_04 = ResourceLoader.load(GAME_LEVEL_04)
    _level_05 = ResourceLoader.load(GAME_LEVEL_05)
    _level_06 = ResourceLoader.load(GAME_LEVEL_SELECTION)

func goto_scene(path):
    # This function will usually be called from a signal callback,
    # or some other function from the running scene.
    # Deleting the current scene at this point might be
    # a bad idea, because it may be inside of a callback or function of it.
    # The worst case will be a crash or unexpected behavior.

    # The way around this is deferring the load to a later time, when
    # it is ensured that no code from the current scene is running:

    call_deferred("_deferred_goto_scene", path)

func _deferred_goto_scene(path):
    # Immediately free the current scene,
    # there is no risk here.
    if current_scene != null:
        current_scene.free()
        # Instance the new scene.
    current_scene = path.instantiate()

    # Add it to the active scene, as child of root.
    get_tree().get_root().add_child(current_scene)

    # Optional, to make it compatible with the SceneTree.change_scene() API.
    get_tree().set_current_scene(current_scene)

func start_level(_level_id : int) -> void:
    match _level_id:
        0:
            goto_scene(_level_00)
        1:
            goto_scene(_level_01)
        2:
            goto_scene(_level_02)
        3:
            goto_scene(_level_03)
        4:
            goto_scene(_level_04)
        5:
            goto_scene(_level_05)
        6:
            goto_scene(_level_06)
        _:
            goto_scene(_level_06)
    
