TriggerEvent('NB-Base:addGroupCommand',  'setgroup', 'admin', function(source, args, user)
    local target = tonumber(args[1]) -- player id
    local group = tostring(args[2]) -- group [admin, mod, dev, owner]
    local player = NB.Functions.getPlayer(target)
    if target ~= nil then
        if player then
            if NB.UserGroup[group] then
                NB.Functions.setGroup(player, group)
                TriggerClientEvent('okokNotify:Alert', player, "Success", "Added person to the group!", 5000, 'success')
            else
                -- Notifications
            end
        else
            -- Notifications
        end
    end
    end, function(source, args, user)
        -- Notifications
end)


TriggerEvent('NB-Base:addGroupCommand', 'console', 'admin', function(source, args, user)
    local msg = args[1]
    TriggerClientEvent("chatMessage", -1, "CONSOLE: " .. nessage, 3)
end, function(source, args, user)
    -- add notification
end)

TriggerEvent('MP-Base:addGroupCommand', 'EditPrio', 'admin', function(source, args, user)
    local Player = MP.Functions.getPlayer(tonumber(args[1]))
    local level = tonumber(args[2])
    if Player ~= nil then
        UpdatePriority(tonumber(args[1]), level)
    else
        -- Notifications
    end
end)