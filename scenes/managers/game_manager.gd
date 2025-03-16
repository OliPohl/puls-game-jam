extends Node
@onready var _scene_manager : Scene_Manager =$Scene_Manager
signal game_started()
signal game_paused(_value : bool)
signal game_over()
signal game_win()

enum GameState {
    MENU,# only menu scene
    LEVEL_SELECTION, ## on game level selection
    GAME_RUNNING, # on every level and still running
    GAME_RESUME, # short step to switch to running
    GAME_OVER, # after game  lose
    GAME_WIN, # after game  win
    PAUSE # on every level and still paused
}
### public variables
var gameresult_time : float  = 0
var gameresult_objects : int = 0
var gameresult_deaths : int = 0
### current variables
var current_scene : Node2D
var current_level  : int = 0
var current_game_state : GameState = GameState.MENU
## RESET GAME RESULT
func reset_gameresults() -> void:
    gameresult_deaths = 0
    gameresult_objects = 0
    gameresult_time = 0
func on_game_win() -> void:
    ## SHOW UI WIN PANEL
    game_win.emit()
    current_game_state = GameState.GAME_OVER
    ## PAUSE GAME
    get_tree().paused = true
    ## SAVE VARIABLES
func on_game_over() -> void:
    ## SHOW UI GAME OVER PANEL
    game_over.emit()
    ## PAUSE GAME
    get_tree().paused = true
    current_game_state = GameState.GAME_OVER

###############################################
####
####             START LEVEL MECHANIC
####
###############################################
func start_level(_level_id : int):
    current_level = _level_id
    if _level_id == 6:
        ## LEVEL SELECTER
        current_level= 0
        _scene_manager.start_level(6)
        change_game_state(GameState.LEVEL_SELECTION)
    if _level_id == 0:
        current_level= _level_id
        UiManager.start_menu()
        _scene_manager.start_level(_level_id)
        change_game_state(GameState.MENU)
    else:
        current_level= _level_id
        UiManager.on_set_game_timer( (_level_id * 60))
        _scene_manager.start_level(_level_id)
        change_game_state(GameState.GAME_RUNNING)
###############################################
func Win_Game():
    change_game_state(GameState.GAME_WIN)
func Pause_Game():
    change_game_state(GameState.PAUSE)
func Resume_Game():
    change_game_state(GameState.GAME_RESUME)
## CHANGE GAMESTATE (MENU,LEVEL_SELECTION,GAME_RUNNING,GAME_RESUME,GAME_OVER,GAME_WIN, PAUSE)
func change_game_state( _gamestate: GameState) -> void:
    match _gamestate:
        GameState.MENU:
            get_tree().paused = false
            AudioManager._on_menu_changed()
            ## Set Ui to Menu
            UiManager.set_game_hud(false)
            current_game_state = GameState.MENU

        GameState.GAME_RUNNING:
            get_tree().paused = false
            game_paused.emit(false)
            ## Set UI to Game
            UiManager.set_game_hud(true)
            current_game_state = GameState.GAME_RUNNING
            ## scenemanager
            game_started.emit()
        GameState.GAME_RESUME:
            get_tree().paused = false
            game_paused.emit(false)
            ## Set UI to Game
            UiManager.set_game_hud(true)
            current_game_state = GameState.GAME_RUNNING
        GameState.PAUSE:
            current_game_state = GameState.PAUSE
            get_tree().paused = true
            game_paused.emit(true)
            UiManager.start_level_selection()

        GameState.GAME_OVER:
            current_game_state = GameState.GAME_OVER
            get_tree().paused = true
            game_over.emit()

        GameState.GAME_WIN:
            current_game_state = GameState.GAME_WIN
            get_tree().paused = true
            game_win.emit()
        GameState.LEVEL_SELECTION:
            current_game_state = GameState.LEVEL_SELECTION
            ### set all menus false
            AudioManager._on_menu_changed()
            UiManager._on_game_in_level_selection()
            get_tree().paused = false
        _:
            print("default")
