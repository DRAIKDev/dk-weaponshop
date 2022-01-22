fx_version 'cerulean'
games {'gta5'}

author 'Draik <! Draik#3986>'
description 'ESX WEAPON SHOP OPTIMICED'
version '1.0.0'

shared_scripts "sh-config.lua"
server_scripts {
	'@mysql-async/lib/MySQL.lua','@es_extended/locale.lua','locales/de.lua','locales/br.lua','locales/en.lua','locales/fi.lua','locales/fr.lua','locales/es.lua','locales/pl.lua','locales/sv.lua','s-main.lua'
}

client_scripts {
	'@es_extended/locale.lua','locales/de.lua','locales/br.lua','locales/en.lua','locales/fi.lua','locales/fr.lua','locales/es.lua','locales/pl.lua','locales/sv.lua','c-main.lua','c-submain.lua'
}
