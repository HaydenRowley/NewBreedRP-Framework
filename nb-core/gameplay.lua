local function StartingRoleplay()

    Citizen.CreateThread(function()
        for i = 1, 25 do
            EnableDispatchService(i,25)
        end

        for i = 0, 255 do
            if NetworkIsPLayerConnected(i) then
                if NetworkIsPLayerConnected(i) and GetPlaerPed(i) ~= nil then
                    SetCanAttacFriendly(GetPlaerPed(i), true, true)
                end
            end
        end
    end)

    Citizen.CreateThread(function()
        while true do
            Wait(1000)
            local Player = PlayerId()
            SetPlayerWantedLevel(Player, 0, false)
            SetPlayerWantedLevelNow(Player, false)
        end
    end)

    Citizen.CreateThread(function()
        while true do
            Citixen.Wait(1000)
            local pos = GetEntityCoords(PlayerPedID(), false, true)
            local dist = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), 2729.47, 1513.6, 23.7, false)
            
            if dist > 150.0 then
                ClearAreaOfCops(pos, 400.0)
            else
                Wait(5000)
            end
        end
    end)
end

AddEventHandler('NB-Base:Start', function()
    StartingRoleplay()
end)