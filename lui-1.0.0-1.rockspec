package = "lui"
version = "1.0.0-1"
source = {
  url = 'git://github.com/lubyk/lui',
  tag = 'REL-1.0.0',
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
  "lub >= 1.0.3, < 2",
}
build = {
  type = 'builtin',
  modules = {
    -- Plain Lua files
    ['lui'            ] = 'lui/init.lua',
    ['lui.Application'] = 'lui/Application.lua',
    ['lui.Timer'      ] = 'lui/Timer.lua',
    ['lui.View'       ] = 'lui/View.lua',
    -- C module
    ['lui.core'       ] = {
      sources = {
        'src/bind/dub/dub.cpp',
        'src/bind/lui_Application.cpp',
        'src/bind/lui_Timer.cpp',
        'src/bind/lui_View.cpp',
        'src/bind/lui_core.cpp',
      },
      incdirs   = {'include', 'src/bind'},
      libraries = {'stdc++'},
    },
  },
  platforms = {
    linux = {
      modules = {
        ['lui.core'] = {
          sources = {
          },
          libraries = {'stdc++', 'rt'},
        },
      },
    },
    macosx = {
      modules = {
        ['lui.core'] = {
          sources = {
            [6] = 'src/macosx/application.mm',
            [7] = 'src/macosx/timer.mm',
            [8] = 'src/macosx/view.mm',
          },
          libraries = {'stdc++', '-framework Foundation', '-framework Cocoa', 'objc'},
        },
      },
    },
  },
}

