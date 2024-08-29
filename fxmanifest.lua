fx_version 'cerulean'
game 'gta5'

author 'Abdelrmb'
description 'F5 Menu'
version '1.0.0'

client_scripts {
    'client.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/css/styles.css',
    'html/js/menu.js',
    'html/img/banner.png'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}

dependencies {
    'es_extended',
    'oxmysql'
}
