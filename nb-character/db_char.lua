NB.DB = NB.DB or {}
NB.AdminPlayer = {}

NB.DB.LoadCharacter = function(source, lisence, identifier, cid)
    local src = source
    local PlayerData = {
        identifier = identifier,
        lisence = lisence,
        cid = cid,
        name = GetPlayerName(src),
        cash = NB.Starting.Cash,
        bank = NB.Starting.Bank,
        citizenid = '' .. cid .. ''
    }

    NB.Functions.LoadPlayer(source, PlayerData, cid)

end

NB.DB.doesUserExist = function(identifier, callback)
    TriggerEvent('NB-Base:server:doesUserExist', identifier, callback)
end

NB.DB.SavePlayer = function(source, identifier)
    print('[NB-Base] ' ..GetPlayerName(source) .. ' was saved')
end

RegisterServerEvent('NB-Admin:Setup')
AddEventHandler('NB-Admin:Setup', function(source, identifier) 
    NB.Admin.Setup(source, identifier)
end)

NB.Admin.Setup = function(source, identifier) 
    exports['ghmattimysql']:execute('SELECT * FROM ranking WHERE identifier = @identifier', {['@identifier'] = identifier}, function(result)
        local selfA = {}
        selfA.Data = {}
        selfA.Functions = {}
        selfA.Data.identifier = result[1].identifier
        selfA.Data.usergroup = result[1].usergroup

        selfA.Functions.setGroup = function(group)
            selfA.Data.usergroup = group
            NB.Functions.setGroup(selfA, group)
        end

        NB.APlayers[source] = selfA
        print(selfA.Data.usergroup)
        ExecuteCommand('add_principal identifier.' .. result[1].identifier .. " group." .. selfA.Data.usergroup)
        print('[NB] ' ..result[1].identifier..', Updated to Group: '..selfA.Data.usergroup.. 'successfully')
    end)
end