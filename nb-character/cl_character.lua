local seclectedChar = false
local cam = nil
local cam2 = nil

local bannedName = {}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if NetworkIsSessionStarted() then
            TriggerServerEvent('NB-Base:char:Joined')
            TriggerEvent('NB-Base:char:StartCamera')
            TriggerEvent('NB-ui:client:CloseCharUI')
            TriggerEvent('NB-Base:PlayerLogin')
end)