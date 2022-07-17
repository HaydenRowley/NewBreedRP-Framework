TriggerEvent('NB-Base:addGroupCommand',  'setgroup', 'admin', function(source, args, user)
    local target = tonumber(args[1]) -- player id
    local group = tostring(args[2]) -- group [admin, mod, dev, owner]
    local player = NB.Functions.getPlayer(target)
    if target ~= nil then
        if player then
           if NB.UserGroups[group] then
            NB.Functions.setGroup(player, group)
            -- add notification
           else
            -- add notification
           end
        else
            --add notification
        end 
    end, function(source, args, user)
        -- No perm notification
    end
end)