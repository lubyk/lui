--[[----------------
  # Lubyk GUI module

  This module contains an OpenGL 3 based GUI. 

  This module is part of [lubyk](http://lubyk.org) project.  
  Install with [luarocks](http://luarocks.org) or [luadist](http://luadist.org).

    $ luarocks install lui    or    luadist install lui
  
--]]--------------------
local lub = require 'lub'
local lib = lub.Autoload 'lui'

-- Current version of 'lui' respecting [semantic versioning](http://semver.org).
lib.VERSION = '1.0.0'

lib.DEPENDS = { -- doc
  -- Compatible with Lua 5.1, 5.2 and LuaJIT
  "lua >= 5.1, < 5.3",
  -- Uses [Lubyk base library](http://doc.lubyk.org/lub.html)
  'lub >= 1.0.3, < 2',
}

-- nodoc
lib.DESCRIPTION = {
  summary = "Lubyk GUI module.",
  detailed = [[
    A pure OpenGL based GUI.
  ]],
  homepage = "http://doc.lubyk.org/lui.html",
  author   = "Gaspard Bucher",
  license  = "MIT",
}

-- nodoc
lib.BUILD = {
  github    = 'lubyk',
  includes  = {'include', 'src/bind'},
  libraries = {'stdc++'},
  platlibs = {
    linux   = {'stdc++', 'rt'},
    macosx  = {
      'stdc++',
      '-framework Foundation',
      '-framework Cocoa',
      'objc',
    },
  },
}

-- nodoc
function lib.bootstrap(class, orig, ...)
  -- Make sure lui.Application is created first
  lib.Application()
  class.new = orig
  return orig(...)
end

return lib
