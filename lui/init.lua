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
  'lub >= 1.0.3, < 1.1',
}

function lib.bootstrap(class, orig, ...)
  -- Make sure we create the app
  lib.Application()
  -- Use original function from now
  class.new = orig
  -- Execute original function
  return orig(...)
end

return lib
