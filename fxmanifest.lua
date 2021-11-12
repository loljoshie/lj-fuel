fx_version 'cerulean'
game 'gta5'

description 'lj-fuel'
version '1.2'
author 'github.com/loljoshie'

client_scripts {
	'config.lua',
	'functions/functions_client.lua',
	'source/fuel_client.lua'
}

server_scripts {
	'config.lua',
	'source/fuel_server.lua'
}

--[[ shared_script {
	'@qb-core/import.lua' -- if you are using older version of qbcore you'll have to uncomment shared_scripts
} ]]

exports {
	'GetFuel',
	'SetFuel'
}
