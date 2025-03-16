extends Node
#################################### PLAY AUDIO ##################################
###
### AudioManager.play_sound(AudioManager.Sound.CLICK)
### AudioManager.play_sound(AudioManager.Sound.HIT)
### AudioManager.play_sound(AudioManager.Sound.FLAG)
### AudioManager.play_sound(AudioManager.Sound.INTERACT)
### AudioManager.play_sound(AudioManager.Sound.WIN)
### AudioManager.play_sound(AudioManager.Sound.LOSE)
###
###################################################################################
@onready var _audio_player_hit : AudioStreamPlayer =$Player_Hit_Sound
@onready var _audio_player_flag : AudioStreamPlayer =$Player_flag_Sound
@onready var _audio_player_click : AudioStreamPlayer =$Player_Click_Sound

@onready var _audio_player_interact : AudioStreamPlayer =$Player_Interact_Sound
@onready var _audio_player_win : AudioStreamPlayer =$Player_Win_Sound
@onready var _audio_player_lose : AudioStreamPlayer =$Player_Lose_Sound

@onready var _music_menu : AudioStreamPlayer =$Music_Menu
@onready var _music_game : AudioStreamPlayer =$Music_Game

var master_index: int

var sfx_index:int

var music_index : int

func _ready() -> void:
    master_index= AudioServer.get_bus_index("Master")
    sfx_index= AudioServer.get_bus_index("SFX")
    music_index= AudioServer.get_bus_index("Music")
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
### Sound.HIT, FLAG, CLICK, INTERACT,WIN,LOSE
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
            print("error- default")

func on_master_volume(_value :float) ->void:
    AudioServer.set_bus_volume_db(master_index,linear_to_db(_value))

func on_sfx_volume(_value : float ) -> void:
    AudioServer.set_bus_volume_db(sfx_index, linear_to_db(_value))

func on_music_volume(_value: float) -> void:
    AudioServer.set_bus_volume_db(music_index,linear_to_db(_value))