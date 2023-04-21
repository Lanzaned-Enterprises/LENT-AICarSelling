-- [[ QBCore ]] --
QBCore = exports['qb-core']:GetCoreObject()

-- [[ functions ]] --
function comma_value(amount)
    local formatted = amount
    local k
    while true do
        formatted, k = string.gsub(formatted, '^(-?%d+)(%d%d%d)', '%1,%2')
        if (k == 0) then
            break
        end
    end
    return formatted
end

-- [[ Net Events ]] --
RegisterNetEvent('LENT-AICarSelling:Server:SellClosestCar', function(plate)
    local src = source
    local plate = plate
    local Player = QBCore.Functions.GetPlayer(src)

    local result = MySQL.query.await('SELECT plate FROM player_vehicles WHERE plate = ?', { plate })
    if result[1] ~= nil then
        MySQL.query.await('DELETE FROM player_vehicles WHERE citizenid = ? AND plate = ?', {
            Player.PlayerData.citizenid,
            plate,
        })
        TriggerClientEvent('LENT-AICarSelling:Client:Redirect', src)
    else
        TriggerClientEvent('QBCore:Notify', src, 'You don\'t own this vehicle!', 'error', 3000)
    end
end)

RegisterNetEvent('LENT-AICarSelling:Server:Payout', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local cashAmount = math.random(Config.Payout['MinPayout'], Config.Payout['MaxPayout'])
    
    Player.Functions.AddMoney("bank", cashAmount, "Car Sale")
    
    local email = "Hello, Mr." .. Player.PlayerData.charinfo.lastname .. "<br><br> Thanks for your car! We appreciate it! We wired you $" .. comma_value(cashAmount) .. "<br><br> Your receipt ID: <i>" .. math.random(111111, 999999) .. "</i><br><br> Regards, San Andreas DMV"

    local cid = Player.PlayerData.citizenid
    local name = ("%s %s"):format(Player.PlayerData.charinfo.firstname, Player.PlayerData.charinfo.lastname)
    local txt = "Purchased car by the DMV"
    exports['Renewed-Banking']:handleTransaction(cid, "Car Sale", cashAmount, txt, "S.A. DMV", name, "deposit")

    TriggerClientEvent('LENT-AICarSelling:Client:ReceiveMail', src, email)
end)

QBCore.Commands.Add('testai', 'Testing for AI car selling', {}, false, function(source, args)
    TriggerClientEvent('LENT-AICarSelling:Client:ScrapCar', source)
end)