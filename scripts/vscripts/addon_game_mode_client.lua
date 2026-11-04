require( 'libraries/client_server_utils' )
_G.racestable = FormRaceTable(LoadKeyValues("scripts/kv/races.kv"))
print("SetsSettings")
-- SendToConsole("dota_camera_deatheffect 0")
SendToConsole("dota_player_units_auto_attack_mode 2") --All
SendToConsole("dota_summoned_units_auto_attack_mode_2 -1") --Same as hero
SendToConsole("dota_player_channels_require_stop 1")
GCCollect()