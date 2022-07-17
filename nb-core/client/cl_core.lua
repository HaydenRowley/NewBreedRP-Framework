function NB.Base.Start(self)
    Citizen.CreateThread(function() 
        while true do
            if NetworkIsSessionStarted() then
                TriggerEvent('NB-Base:Start')
                TriggerServerEvent('NB-Base:ServerStart')
                break
            end
        end
    end)
end
NB.Base.Start(self)

RegisterNetEvent('NB-Base:client:getObject')
AddEventHandler('NB-Base:client:getObject', function(callback)
    callback(NB)
    print('Called Back ' .. NB )
end)