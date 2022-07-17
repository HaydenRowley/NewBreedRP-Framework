NB.Functions = Nb.Functions or {}
NB.RequestID = Nb.RequestID or {}
NB.ServerCallback = Nb.ServerCallback or {}
NB.ServerCallback = {}
NB.CurrentRequestID = 0

NB.Fucntions.GetKey = function(key) 
    local Keys = {
        ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
        ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
        ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
        ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
        ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
        ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
        ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
        ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
        ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
    }
    return Keys[key]
end

NB.Functions.GetPlayerdata = function(source)
    return NB.PlayerData
end

-- Admin Functions
NB.Functions.DeleteVehicle = function(vehicle)
    SetEntityAsMissionEntity(vehicle, false, true)
    DeleteVehicle(vehicle)
end

NB.Functions.GetVehicleDirection = function()
    local civ = PlayerPedId()
    local civCoord = GetEntityCoords(civ)
    local inDirection = GetOffsetFromEntityinWorldCoords(civ, 0,10,0)
    local rayHandle = StartShapeTestRay(civCoord, inDirection, 10, civ, 0)
    local numRayHandle, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(rayHandle)

    if hit == 1 and GetEntityType(entityHit) == 2 then
        return entityHit
    end
    return nil
end

NB.Functions.DeleteObject = function(obj)
    SetEntityAsMissionEntity(obj, false, true)
    DeleteObject(obj)
end

NB.Functions.GetClosestPlayer = function(coords)
    local players = NB.Functions.GetPlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local coords = coords
    local usePlayerPed = false
    local civ = PlayerPedId()
    local civID = PlayerId()

    if coords == nil then
        usePlayerPed = true
        coords = GetEntityCoords(civ)
    end
    
    for i = 1, #players, 1 do
        local target = GetPlayerPed(players[i])

        if not usePlayerPed or (usePlayerPed and players[i] ~= PlayerId) then
            local targetCoords = GetEntityCoords(target)
            local distance = GetDistanceBetweenCoords(targetCoords, coords.x, coords.y, true)

            if closestDistance == -1 or closestDistance > distance then
                closestPlayer = players[i]
                closestDistance = distance
            end
        end
    end
    return closestPlayer, closestDistance
end

-- Callbacks
NB.Functions.TriggerServerCallback = function(name, cb, ...)
    NB.ServerCallbacks[NB.CurrentRequestID] = cb

    TriggerServerEvent('NB.-Base:server:triggerServerCallback', name, NB.CurrentRequestID, ...)

    if NB.CurrentRequestID < 65535 then
        NB.CurrentRequestID = NB.CurrentRequestID + 1
    else
        NB.CurrentRequestID = 0
    end
end

NB.Functions.GetPlayers = function()
    local MaxPlayer = 120
    local players = {}

    for i = 0, MaxPlayer - 1 do
        local civ = GetPlayerPed(i)
        if DoesEntityExist(civ) then
            table.insert(players,i)
        end
    end
    return players
end



RegisterNetEvent('NB-Base:client:serverCallback')
AddEventHandler('NB-Base:client:serverCallback', function(requestId, ...)
    NB.ServerCallbacks[requestId](...)
    NB.ServerCallbacks[requestId] = nil
end)


-- Other functions
RegisterNetEvent('NB-SetCharacterData')
AddEventHandler('NB-SetCharacterData', function(Player)
    pData = Player
end)