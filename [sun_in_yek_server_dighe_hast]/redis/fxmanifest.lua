-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

fx_version 'cerulean'
game 'common'

use_experimental_fxv2_oal 'yes'
lua54 'yes'

name 'redis-connector'
author 'Riyane <Purpose-Dev>'
version '1.0.0'
license 'MIT'
repository 'https://github.com/Purpose-Dev/redis-connector'
description 'Redis Connector for FiveM servers'

server_script 'dist/index.js'
server_script 'lib/redis.lua'
server_scripts{
    'dist/index.js',
    'lib/redis.lua',
    'flush.lua',
    '@litesql/lib/MySQL.lua',
    'load.lua',
}


convar_category 'RedisConnector' {
    'Configuration',
    {
        { 'Redis Host',         'redis_host',       'CV_STRING',  '127.0.0.1' },
        { 'Redis Port',         'redis_port',       'CV_INT',     '6379' },
        { 'Redis User',         'redis_user',       'CV_STRING',  '' },
        { 'Redis Password',     'redis_password',   'CV_STRING',  '' },
        { 'Redis Debug',        'redis_debug_mode', 'CV_BOOL',    'false' },
        { 'Redis SSL Usage',    'redis_use_ssl',    'CV_BOOL',    'false' },
    }
}
