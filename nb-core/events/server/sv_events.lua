-- Call NB
NB.Functions = Nb.Functions or {}
NB.Commands = {}
NB.CommandsSuggestions = {}
NB.ServerCallbacks = NB.ServerCallbacks or {}
NB.ServerCallback = {}

NB.Functions.RegisterserverCallback = function(name, cb)
    NB.ServerCallback[name] = cb
end

NB.Functions.TriggerServerCallback = function(name, requestId, source, ...)
    if NB.ServerCallback[name] ~= nil then
        NB.ServerCallbacks[name] (source, cb, ...)
    end
end

NB.Functions.getPlayer = function(source)
    if NB.Players[source] ~= nil then
        return NB.Players[source]
    end
end

NB.Functions.AdminPlayer = function(source) -- Admin shit
    if NB.APlayers[source] ~= nil then
        return NB.APlayers[source]
    end
end

RegisterNetEvent('NB-Base:server:UpdatePlayer')
AddEventHandler('NB-Base:server:UpdatePlayer', function()
    local civ = source
    local player = NB.Functions.GetPlayer(civ)
    
    if player then
        Player.Functions.Save()
    end
end)

-- Character SQL 
NB.Functions.CreatePlayer = function(source, Data)
    exports['ghmattimysql']:execute('INSERT INTO players (`identifier`, `license`, `cash`, `bank`) VALUES (@identifier, @license, @name, @cash, @bank', {
    ['identifier'] = Data.identifier,
    ['license'] = Data.license,
    ['name'] = Data.name,
    ['cash'] = Data.cash,
    ['bank'] = Data.bank
    })

    print('[NB-Base] ' .. Data.name .. ' was created successfully')

    NB.Functions.LoadPlayer(source, Data)
end

NB.Functions.LoadPlayer = function(source, pData, cid)
    local src = source
    local identifier = pData.identifier

    Citizen.Wait(7)
    exports['ghmattimysql']:execute('SELECT * FROM players WHERE identifier = @identifier and cid = @cid', {['@identifier'] = identifier, ['@cid'] = cid}, function(restult)
        
        -- Server shit again
        exports['ghmattimysql']:execute('UPDATE players SET name = @name WHERE identifier = @identifier AND cid = @cid', {['@identifier'] = identifier, ['@name'] = pData.name, ['@cid'] = cid})
   
        NB.Player.LoadData(source, identifier, cid)
        Citizen.Wait(7)

        local player = NB.Functions.getPlayer(source)
        TriggerClientEvent('NB-SetCharData', source{
            identifier = result[1].identifier,
            license = result[1].license,
            cid = result[1].cid,
            name = result[1].name,
            cash = result[1].cash,
            bank = result[1].bank,
            citizenid = result[1].citizenid,
        })

        TriggerClientEvent('NB-Base:PlayerLoaded', source)
        -- TriggerClientEvent('NB-')
        -- Trigger admin
    end)
end

NB.Functions.addCommand = function(command, callback, suggestion, args)
    NB.Commands[command] = {}
    NB.Commands[command].cmd = {}
    NB.Commands[command].args = args or -1
    
    if suggestion then
        if not suggestion.params or not type(suggestions.params) == 'table' then suggestion.params = {} end
        if not suggestion.help or not type(suggestions.help) == 'string' then suggestions.help = {} end

        NB.CommandSuggestions[command] = suggestion
    end

    RegisterCommand(command, function(source, args)
        if (#agrs <= NB.Commands[command].args and #args == NB.Commands[command].args) or NB.Commands[command.args == -1] then
            callback(source, args, NB.Players[source])
        end
    end, false)
end

NB.Functions.addGroupCommand = function(command, group, callback, callbackfailed, suggestion, arguments)
    NB.Commands[command] = {}
    NB.Commands[command].perm = group
    NB.Commands[command].cmd = callback
    NB.Commands[command].callbackfailed = callbackfailed
    NB.Commands[command].arguments = arguments or -1

    if suggestion then
        if not suggestion.params or not type(suggestions.params) == 'table' then suggestion.params = {} end
        if not suggestion.help or not type(suggestions.help) == 'string' then suggestions.help = {} end

        NB.CommandSuggestions[command] = suggestion
    end

    ExecuteCommand('add_ace group ' .. group .. ' command ' .. command .. ' allow')

    RegisterCommand(command, function(source, args)
        if (#agrs <= NB.Commands[command].args and #args == NB.Commands[command].args) or NB.Commands[command.args == -1] then
            callback(source, args, NB.Players[source])
        end

        ExecuteCommand('add_ace group.' .. group .. ' command.' .. command .. ' allow')

        RegisterCommand(command, function(source, args)
            local Source = source
            local pData = NB.Functions.AgetPlayer(source)

            if(source ~= 0) then
                if pData ~= nil then
                    if pData.Data.usergroup == NB.Commands[command].group then
                        if((#args <= NB.Commands[command].arguments and #args == NB.Commands[command].arguments) or NB.Commands[command].arguments == -1) then
                            callback(source, args, NB.Players[source])
                        end
                    else
                        callbackfailed(source, args, NB.Players[source])
                    end
                end
            else
                if((#args <= NB.Commands[command].arguments and #args == NB.Commands[command].arguments) or NB.Commands[command].arguments == -1) then
                    callback(source, args, NB.Players[source])
                end
            end
        end)
    end, true)
end

-- Usergroups

NB.Functions.setupAdmin = function(player, group)
    local identifier = player.Data.identifier
    local pCid = player.Data.cid
    exports['ghmattimysql']:execute('DELETE FROM ranking WHERE identifier = @identifier', {['@identifier'] = identifier})
    Wait(1000)

    exports['ghmattimysql']:execute('INSERT INTO ranking (`usergroup`, `identifier`) VALUES (@usergroup, @identifier)', {
        ['@usergroup'] = group,
        ['@identifier'] = identifier
    })
    print('Function Group : ' ..group)
    TriggerClientEvent('NB-Admin:updateGroup', player.Data.PlayerId, group)
end

NB.Functions.BuildCommands = function(source)
    local src = source
    for k,v in pairs(NB.CommandSuggestions) do
        TriggerClientEvent('chat:addSuggestion', src, '/'..k, v.help, v.params)
    end
end

NB.Functions.ClearCommands = function(source)
    local src = source
    for k,v in pairs(NB.CommandSuggestions) do
        TriggerClientEvent('chat:removeSuggestion', src, '/'..k, v.help, v.params)
    end
end