--[[
    Recommanded Maps:
    https://www.gta5-mods.com/maps/sandy-shores-scrapyard
]]

Config = {}

Config.GlobalSettings = {
    ['Phone'] = "qb", -- qb, gks, qs
    ['UseBlips'] = true,
}

Config.Payout = {
    ['MinPayout'] = math.random(12000, 22000),
    ['MaxPayout'] = math.random(25000, 34000),
}

Config.Blips = {
    [1] = {
        ['BlipCoords'] = vector3(-421.11, -1691.18, 19.03),
        ['BlipName'] = 'Scrapyard',
        ['BlipId'] = 605,
        ['BlipColor'] = 0,
    },
    [2] = {
        ['BlipCoords'] = vector3(1131.45, 3592.03, 31.3),
        ['BlipName'] = 'Scrapyard',
        ['BlipId'] = 605,
        ['BlipColor'] = 0,
    },
}