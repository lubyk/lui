package = "lui"
version = "1.0.0-1"
source = {
  url = 'https://github.com/lubyk/lui/archive/REL-1.0.0.tar.gz',
  dir = 'lui-REL-1.0.0',
}
description = {
  summary = "Lubyk GUI module.",
  detailed = [[
      A pure OpenGL based GUI.
    ]],
  homepage = "http://doc.lubyk.org/lui.html",
  license = "MIT"
}

dependencies = {
  "lua >= 5.1, < 5.3",
  "lub >= 1.0.3, < 1.1",
}
build = {
  type = 'builtin',
  modules = {
    -- Plain Lua files
    ['lui'            ] = 'lui/init.lua',
    ['lui.Application'] = 'lui/Application.lua',
    ['lui.Poller'     ] = 'lui/Poller.lua',
    ['lui.Timer'      ] = 'lui/Timer.lua',
    ['lui.View'       ] = 'lui/View.lua',
    -- C module
    ['lui.core'       ] = {
      sources = {
        'src/bind/dub/dub.cpp',
        'src/bind/dub/dub.cpp~',
        'src/bind/lui_Application.cpp',
        'src/bind/lui_core.cpp',
        'src/bind/lui_FileHandle.cpp',
        'src/bind/lui_Timer.cpp',
        'src/bind/lui_View.cpp',
      },
      incdirs   = {'include', 'src/bind'},
      libraries = {'stdc++'},
    },
  },
}


