fx_version "cerulean"
game "gta5"
lua54 "yes"

name "mnr_showid"
description "Show ID script to view players IDs above head"
author "IlMelons"
version "1.0.0"
repository "https://github.com/Monarch-Development/mnr_showid"

ox_lib "locale"

shared_scripts {
    "@ox_lib/init.lua",
}

client_scripts {
    "config/*.lua",
    "client/*.lua",
}

server_scripts {
    "server/*.lua",
}

files {
    "locales/*.json",
}