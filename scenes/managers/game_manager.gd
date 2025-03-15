extends Node

signal game_started()
signal game_paused(_value : bool)
signal game_over()
signal game_win()

enum GameState {
    MENU,# only menu scene
    GAME_RUNNING, # on every level and still running
    GAME_OVER, # after game  lose
    GAME_WIN, # after game  win
    PAUSE # on every level and still paused
}

var current_game_state : GameState = GameState.MENU
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
    ## SAVE VARIABLES

func change_game_state( _gamestate: GameState) -> void:
    match _gamestate:
        GameState.MENU:
            get_tree().paused = false
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
            
        GameState.PAUSE:
            current_game_state = GameState.PAUSE
            get_tree().paused = true
            game_paused.emit(true)

        GameState.GAME_OVER:
            current_game_state = GameState.GAME_OVER
            get_tree().paused = true
            game_over.emit()

        GameState.GAME_WIN:
            current_game_state = GameState.GAME_WIN
            get_tree().paused = true
            game_win.emit()
        
        _:
            ## Set Default Ui to Menu
            UiManager.set_game_hud(false)
            current_game_state = GameState.MENU
