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
        TriggerClientEvent('LENT-AICarSelling:Client:SellVehicle', src)
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
    local title = "Car Sale"
    local name = ("%s %s"):format(Player.PlayerData.charinfo.firstname, Player.PlayerData.charinfo.lastname)
    local txt = "Purchased car by the DMV"
    local issuer = "S.A. DMV"
    local reciver = name
    local type = "deposit"
    exports['Renewed-Banking']:handleTransaction(cid, title, cashAmount, txt, issuer, reciver, type)

    TriggerClientEvent('LENT-AICarSelling:Client:ReceiveMail', src, email)
end)