extends Node

var config = ConfigFile.new()

const SETTING_FILE_PATH = "user://settings.ini"
func delete_all_data() -> void:
    ### SAVE old data
    config.save("user://_olddata.ini")
    ### Create new data
    _create_new_data()
    GameManager.start_level(6)

func _create_new_data()->void:
    config.set_value("video", "fullscreen", false)
    config.set_value("video", "vsync", true)

    config.set_value("audio", "master_volume", 0.4)
    config.set_value("audio", "sound_volume", 0.4)
    config.set_value("audio","music_volume", 0.4)

    config.set_value("level","level_01", true)
    config.set_value("level","level_02", false)
    config.set_value("level","level_03", false)
    config.set_value("level","level_04", false)
    config.set_value("level","level_05", false)
    config.set_value("level","level_06", false)

    config.set_value("highscore", "level_01", 0)
    config.set_value("highscore", "level_02", 0)
    config.set_value("highscore", "level_03", 0)
    config.set_value("highscore", "level_04", 0)
    config.set_value("highscore", "level_05", 0)
    config.set_value("highscore", "level_06", 0)
    ## save to file
    config.save(SETTING_FILE_PATH)
func _ready() -> void:
    ### if no file exist, create new config
    if !FileAccess.file_exists(SETTING_FILE_PATH):
        _create_new_data()
    else:
        ### load exist data
        config.load(SETTING_FILE_PATH)

### main functions video
func save_video_settings( _key :String, _value) -> void:
    config.set_value("video", _key, _value)
    config.save(SETTING_FILE_PATH)

func load_video_settings():
    var video_settings = {}
    for _key in config.get_section_keys("video"):
        video_settings[_key] = config.get_value("video", _key)
    return video_settings

### main func audio
func save_audio_settings(_key : String, _value) -> void:
    config.set_value("audio", _key, _value)
    config.save(SETTING_FILE_PATH)

func load_audio_setting():
    var audio_settings = {}
    for _key in config.get_section_keys("audio"):
        audio_settings[_key] = config.get_value("audio", _key)
    return audio_settings
### main func level
func save_level_settings(_key : String, _value) -> void:
    config.set_value("level", _key, _value)
    config.save(SETTING_FILE_PATH)

func load_level_setting():
    var level_settings = {}
    for _key in config.get_section_keys("level"):
        level_settings[_key] = config.get_value("level", _key)
    return level_settings

### main func highscore
func save_highscore_settings(_key : String, _value) -> void:
    config.set_value("highscore", _key, _value)
    config.save(SETTING_FILE_PATH)

func load_highscore_setting():
    var highscore_settings = {}
    for _key in config.get_section_keys("highscore"):
        highscore_settings[_key] = config.get_value("highscore", _key)
    return highscore_settings