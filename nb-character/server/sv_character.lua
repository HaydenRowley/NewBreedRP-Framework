RegisterServerEvent('NB-Base:char:join')
AddEventHandler('NB-Base:char:join', function()
    local src = source
    local id 
    for k,v in ipairs(GetPlayerIdentifiers(src)) do
        if string.sub(v, 1, string.len('steam:')) == 'steam' then
            id = v
            break
        end
    end

    if not id then
        DropPlayer(src, 'Identifier not found, open steam!')
    else
        TriggerClientEvent('NB-Base:char:setupCharacters', src)
    end
end)

RegisterServerEvent('NB-Base:char:ServerSelect')
AddEventHandler('NB-Base:char:ServerSelect', function(cid)
    local src = source
    local identifier = GetPlayerIdentifiers(src)[1] -- Steam identifier
    local license = GetPlayerIdentifiers(src)[2] -- Fivem

    NB.DB.LoadCharacter(src, identifier, license, cid)
end)

NB.Functions.RegisterserverCallback('NB-Base:getChar', function(source, cb)
    local id = GetPlayerIdentifiers(src)[1]

    exports['ghmattimysql']:execute('SELECT * FROM players WHERE identifier = @identifier', {['@identifier'] = id}, function(restult)
        if result then
            cb(result)
        end
    end)
end)

RegisterServerEvent('NB-Base:deleteChar')
AddEventHandler('NB-Base:deleteChar', function(charData)
    local cid = charData.cid
    local name = 'First: ' .. charData.firstname .. ' Last: ' .. charData.lastname .. ''
    local src = source
    local identifier = GetPlayerIdentifiers(src)[1]
    local charname = 'First: ' .. charData.firstname .. ' Last: ' .. charData.lastname .. ''
    local citizenId = '' .. cid ..''

    exports['ghmattimysql']:execute('DELETE FROM players WHERE citizenId = @citizenId', {['@citizenId'] = citizenId})

    -- Add Discord Logs

    TriggerClientEvent('NB-Base:char:setupCharacters', src)
end)

RegisterServerEvent('NB-Base:server:createCharacter')
AddEventHandler('NB-Base:server:createCharacter', function(cData)
    local src = source
    local identifier = GetPlayerIdentifiers(src)[1]
    local license = GetPlayerIdentifiers(src)[2]
    local name = GetPlayerName(src)
    local cid = cData.cid
    local citizenId = '' .. cData.cid .. ''
    local charname = 'First: ' ..cData.firstname .. ' Last: ' .. cData.lastname .. ''

    exports['ghmattimysql']:execute('INSTERT INTO playrs (`identifier`, `license`, `name`, `cid`, `cash`, `bank`, `firstname`, `lastname`, `sex`, `dob`, `phone`, `citizenid`) VALUES (@identifier, @license, @name, @cid, @cash, @bank, @firstname, @lastname, @sex, @dob, @phone, @citizenid', {
        ['identifier'] = identifier,
        ['license'] = license,
        ['name'] = name,
        ['cid'] = cid,
        ['cash'] = NB.Starting.Cash,
        ['bank'] = NB.Starting.Bank,
        ['firstname'] = cData.firstname,
        ['lastname'] = cData.lastname,
        ['sex'] = cData.sex,
        ['dob'] = cData.dob,
        ['phone'] = math.random(0000000000, 9999999999),
        ['citizenid'] = citizenId
    })

    -- logs again 

    TriggerClientEvent('NB-Base:char:setupCharacters', src)
end)