local seclectedChar = false
local cam = nil
local cam2 = nil

local bannedNames = {}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if NetworkIsSessionStarted() then
            TriggerServerEvent('NB-Base:char:Joined')
            TriggerEvent('NB-Base:char:StartCamera')
            TriggerEvent('NB-ui:client:CloseCharUI')
            TriggerEvent('NB-Base:PlayerLogin')
            selectedChar(true)
            return
        end
    end
end)

RegisterNetEvent('NB-Base:char:Secting')
AddEventHandling('NB-Base:char:Secting', function() 
    selectedChar(true)
end)

GetCID = function(source, cb)
    local src = source
    TriggerServerEvent('NB-Base:GetID', src)
end

RegisterNUICallBack('createCharacter', function(data)
    local CharData = data.CharData
    for theData, value in pairs(charData) do
        if theData == 'firstname' or theData == 'lastname' then
            reason = verifyName(value)
            print(reason) -- Remove Later

            if reason ~= '' then
                break
            end
        end
    end

    if reason == '' then
        TriggerServerEvent('NB-Base:server:createCharacter', CharData)
    end
end)

function verifyName(name)
    for k, v in pairs(bannedNames) do
        if name == v then
            local reason = 'You cant use that name' 
            TriggerServerEvent('NB-Admin:disconnect', reason)
        end
    end

    local nameLength = string.len(name)
    if nameLength > 25 or nameLength < 2 then
        return 'Your name is to short or long'
    end

    local count = 0
    for i in name:gmatch("[abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ-]") do
        count = count +1
    end
    if count ~= nameLength then
        return 'Your name contains special characters, please change this'
    end

    local spacesInName = 0
    local spacesWithUpper = 0
    for word in string.gmatch(name, "%S+") do
        if string.match(word, "%u") then
            spacesWithUpper = spacesWithUpper +1
        end

        spacesInName = spacesInName + 1
    end

    if spacesInName > 1 then
        return "Your name must contain two spaces"
    end
    if spacesWithUpper ~= spacesInName then
        return "Your name must start with a capital letter"
    end

    return ""
end

RegisterNUICallBack('deleteCharacter', function(data)
    local CharData = data
    TriggerServerEvent('NB-Base:deleteChar', CharData)
end)