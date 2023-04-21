-- [[ Metadata ]] --
fx_version 'cerulean'
games { 'gta5' }

-- [[ Author ]] --
author 'Izumi S. <https://discordapp.com/users/871877975346405388>'
description 'Lananed Development | AI Car Selling'
discord 'https://discord.lanzaned.com'
github 'https://github.com/Lanzaned-Enterprises/LENT-AICarSelling'
docs 'https://docs.lanzaned.com/'

-- [[ Version ]] --
version '0.0.0'

-- [[ Dependencies ]] --
dependencies {
    'qb-core',
}

-- [[ Files ]] --
shared_scripts {
    -- Config Files
    'shared/*.lua',
}

server_scripts {
    -- SQL Dependency
    '@oxmysql/lib/MySQL.lua',
    -- Server Events
    'server/*.lua',
}

client_scripts {
    -- Polyzone Dependency
    '@PolyZone/client.lua',
	'@PolyZone/BoxZone.lua',
	'@PolyZone/ComboZone.lua',
    -- Client Events
    'client/*.lua',
}

-- [[ Tebex ]] --
lua54 'yes'