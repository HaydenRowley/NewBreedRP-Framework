fx_version = 'adamant'
game 'gta5'

dependency 'ghmattimysql'

scripts {
    'nb-character/db-char.lua',
    'nb-character/player.lua',
}

shared_scripts {

}

client_scripts {
    'nb-character/client/cl_character.lua',
}

server_scripts {
    'nb-character/server/sv_character.lua',
}