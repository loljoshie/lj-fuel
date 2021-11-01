fx_version 'bodacious'
game 'gta5'

description 'lj-fuel'
version '1.1'
author 'github.com/loljoshie'


shared_script '@qb-core/import.lua'

client_scripts {
	'config.lua',
	'functions/functions_client.lua',
	'source/fuel_client.lua'
}

server_scripts {
	'config.lua',
	'source/fuel_server.lua'
}

exports {
	'GetFuel',
	'SetFuel'
}
