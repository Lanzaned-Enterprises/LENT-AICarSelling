-- [[ QBCore ]] --
QBCore = exports['qb-core']:GetCoreObject()

-- [[ Variables ]] --
local inSellingZone = false
local isInSellZone = nil

-- [[ Resource Metadata ]] --
AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        exports['qb-radialmenu']:RemoveOption(6)
    end
end)

-- [[ Functions ]] --


-- [[ Zone Check ]] --
local zone = PolyZone:Create({
    vector2(1136.1, 3596.57),
    vector2(1135.95, 3583.19),
    vector2(1125.0, 3583.06),
    vector2(1124.94, 3596.56),
    }, {
    name = "bcSellZone",
    minZ = 30.1,
    maxZ = 34.1,
})

local zone2 = PolyZone:Create({
    vector2(-432.20, -1695.73),
    vector2(-425.77, -1674.58),
    vector2(-415.30, -1677.41),
    vector2(-424.40, -1699.41),
    }, {
    name = "bcSellZone",
    minZ = 19.01,
    maxZ = 19.02,
})

zone:onPlayerInOut(function(isPointInside)
    if isPointInside then
        inSellingZone = true
        exports['qb-core']:DrawText('F1 - To sell car!', 'left')
        if IsPedInAnyVehicle(PlayerPedId()) then
            exports['qb-radialmenu']:AddOption(6, {
                id = 'lent_sellvehicle',
                title = 'Sell Vehicle',
                icon = 'square-parking',
                type = 'client',
                event = 'LENT-AICarSelling:Client:ScrapCar',
                shouldClose = true
            })
        end
    else
        inSellingZone = false
        exports['qb-core']:HideText()
        exports['qb-radialmenu']:RemoveOption(6)
    end
end)
zone2:onPlayerInOut(function(isPointInside)
    if isPointInside then
        inSellingZone = true
        exports['qb-core']:DrawText('F1 - To sell car!', 'left')
        if IsPedInAnyVehicle(PlayerPedId()) then
            exports['qb-radialmenu']:AddOption(6, {
                id = 'lent_sellvehicle',
                title = 'Sell Vehicle',
                icon = 'square-parking',
                type = 'client',
                event = 'LENT-AICarSelling:Client:ScrapCar',
                shouldClose = true
            })
        end
    else
        inSellingZone = false
        exports['qb-core']:HideText()
        exports['qb-radialmenu']:RemoveOption(6)
    end
end)

-- [[ Net Events ]] --
RegisterNetEvent('LENT-AICarSelling:Client:ScrapCar', function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    local plate = GetVehicleNumberPlateText(vehicle)
    TriggerServerEvent('LENT-AICarSelling:Server:SellClosestCar', plate)
end)

RegisterNetEvent('LENT-AICarSelling:Client:SellVehicle', function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    local plate = GetVehicleNumberPlateText(vehicle)
    NetworkRequestControlOfEntity(vehicle)
    QBCore.Functions.DeleteVehicle(vehicle)
end)

RegisterNetEvent('LENT-AICarSelling:Client:ReceiveMail', function(email)
    if Config.GlobalSettings['Phone'] == 'qb' then 
        TriggerServerEvent('qb-phone:server:sendNewMail', {
            sender = "San Andreas DMV",
            subject = "Vehicle Sale",
            message = email,
        })
    elseif Config.GlobalSettings['Phone'] == 'gks' then
        TriggerServerEvent('gksphone:NewMail', {
            sender = "San Andreas DMV",
            image = '/html/static/img/icons/mail.png',
            subject = 'Vehicle Sale',
            message = email,
        })
    elseif Config.GlobalSettings['Phone'] == 'qs' then
        TriggerServerEvent('qs-smartphone:server:sendNewMail', {
            sender = 'San Andreas DMV',
            subject = 'Vehicle Sale',
            message = email,
            button = {}
        })
    end
end)

RegisterNetEvent('LENT-AICarSelling:Client:Redirect', function()
    TriggerEvent('LENT-AICarSelling:Client:SellVehicle')
    TriggerServerEvent('LENT-AICarSelling:Server:Payout')
end)

-- [[ Blips ]] --
if Config.GlobalSettings['UseBlips'] then
    local BlipSpawned = false
    local SpawnedBlips = {}

    AddEventHandler('onResourceStop', function(resource)
        if resource == GetCurrentResourceName() then
            RemoveBlips()
        end
    end)

    CreateThread(function()
        if not BlipSpawned then
            for blip, _ in pairs(Config.Blips) do
                local CreatedBlip = AddBlipForCoord(Config.Blips[blip]["BlipCoords"]["x"], Config.Blips[blip]["BlipCoords"]["y"], Config.Blips[blip]["BlipCoords"]["z"])
                SetBlipSprite(CreatedBlip, Config.Blips[blip]["BlipId"])
                SetBlipDisplay(CreatedBlip, 2)
                SetBlipScale(CreatedBlip, 0.8)
                SetBlipColour(CreatedBlip, Config.Blips[blip]["BlipColor"])
                SetBlipAlpha(CreatedBlip, 256)
                SetBlipAsShortRange(CreatedBlip, true)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString(Config.Blips[blip]["BlipName"])
                EndTextCommandSetBlipName(CreatedBlip)
                table.insert(SpawnedBlips, CreatedBlip)
            end
            
            BlipSpawned = true
        end
    end)

    function RemoveBlips()
        for i, CreatedBlip in pairs(SpawnedBlips) do
            RemoveBlip(CreatedBlip)
        end
    end
end