--[[------------------------------------------------------

  # Window

  GUI window with an OpenGL 3 context.

  Usage example:
  
    local lub = require 'lub'
    local lui = require 'lui'

    win = lui.Window()


--]]------------------------------------------------------
local lub  = require 'lub'
local lui  = require 'lui'
local core = require 'lui.core'

local lib  = core.Window
local new  = lib.new

function lib.new(...)
  return lui.bootstrap(lib, new, ...)
end

return lib
