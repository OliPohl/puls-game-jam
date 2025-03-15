extends Node

@onready var _audio_player_hit : AudioStreamPlayer =$Player_Hit_Sound
@onready var _audio_player_flag : AudioStreamPlayer =$Player_flag_Sound
@onready var _audio_player_click : AudioStreamPlayer =$Player_Click_Sound

@onready var _audio_player_interact : AudioStreamPlayer =$Player_Interact_Sound
@onready var _audio_player_win : AudioStreamPlayer =$Player_Win_Sound
@onready var _audio_player_lose : AudioStreamPlayer =$Player_Lose_Sound

@onready var _music_menu : AudioStreamPlayer =$Music_Menu
@onready var _music_game : AudioStreamPlayer =$Music_Game
func _ready() -> void:
    GameManager.game_started.connect(_on_game_changed)
    GameManager.game_paused.connect(_on_game_paused)
enum Sound {
    HIT,
    FLAG,
    CLICK,
    INTERACT,
    WIN,
    LOSE
}
func _on_game_paused (_value : bool )->void:
    _on_menu_changed()
func _on_game_changed()->void:
    _music_menu.stream_paused = true
    _music_game.play()
func _on_menu_changed() -> void:
    _music_game.stream_paused = true
    _music_menu.play()

func play_sound(_sound : Sound) ->void:
    match _sound:
        Sound.HIT:
            _audio_player_hit.play()
        Sound.FLAG:
            _audio_player_flag.play()
        Sound.CLICK:
            _audio_player_click.play()
        Sound.INTERACT:
            _audio_player_interact.play()
        Sound.WIN:
            _audio_player_win.play()
        Sound.LOSE:
            _audio_player_lose.play()
        _:
            _audio_player_hit.play()