resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

client_script "@warmenu/warmenu.lua"

client_script('config.lua')
client_script('cl_sc.lua')

server_script 'versioncheck.lua'
server_script('sv_steam.lua')