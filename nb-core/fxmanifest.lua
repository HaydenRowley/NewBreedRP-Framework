fx_version = 'cerulean'
game 'gta5'

dependency 'ghmattimysql'

scripts {
    'nb-core/shared/shared.lua',
    'nb-core/gameplay.lua',
}

shared_scripts {
    'nb-core/shared/shared.lua',
}

client_scripts {
    'nb-core/client/cl_core.lua',
    'nb-core/events/client/cl_events.lua',
}

server_scripts {
    'nb-core/server/sv_core.lua',
    'nb-core/events/server/sv_events.lua',
    'nb-core/commands/server/sv_commands.lua',
}