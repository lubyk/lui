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

function lib:move(x, y)
  local _, _, w, h = self:frame()
  self:setFrame(x, y, w, h)
end

function lib:resize(w, h)
  local x, y, _, _ = self:frame()
  self:setFrame(x, y, w, h)
end

return lib
