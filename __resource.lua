resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

author 'vjuton | fjuton'
description 'set ped to user'

client_scripts {
  'client/main.lua'
}

server_scripts {
  '@mysql-async/lib/MySQL.lua',
  'server/main.lua'
}
client_script "@essa/acloader.lua"