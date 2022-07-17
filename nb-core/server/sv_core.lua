RegisterServerEvent('NB-Base:ServerStart')
AddEventHandler('NB-Base:ServerStart', function()
    local civ = source
    Citizen.CreateThread(function()
        local Identifier = GetPlayerIdentifiers(civ)[1] -- Steam Identifier
        if not Identifier then
            DropPlayer(civ, "Identifier not located") 
        end
        return
    end)
end)


RegisterNetEvent('NB-Base:server:getObject')
AddEventHandler('NB-Base:server:getObject', function(callback)
    callback(NB)
end)

-- Commands
AddEventHandler('NB-Base:addCommand', function(command, callback, suggestion, args)
    NB.Functions.addCommand(command, callback, suggestion, args)
end)

AddEventHandler('NB-Base:addGroupCommand', function(command, callback, suggestion, args)
    NB.Functions.addGroupCommand(command, callback, suggestion, args)
end)

-- Callback server
RegisterServerEvent('NB-Base:server:triggerServerCallback')
AddEventHandler('NB-Base:server:triggerServerCallback', function(name, requestid, ...)
    local civ = source
    NB.Functions.TriggerServerCallBack(name, requestid, civ, function(...)
        TriggerClientEvent('NB-Base:client:serverCallback', civ, requestid, ...)
    end, ...)
end)