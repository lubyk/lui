--[[------------------------------------------------------

  # Timer

  GUI view with an OpenGL 3 context.

  Usage example:
  
    local lub = require 'lub'
    local lui = require 'lui'

    win = lui.Timer()

  ## Coordinate system

  All coordinates use bottom-left as zero, Y axis pointing up:

    #txt ascii
    
    ^ Y
    |
    |
    +------> X

  This means that you need to specify *bottom-left* corner
  position for window or view position.


--]]------------------------------------------------------
local lub  = require 'lub'
local lui  = require 'lui'
local core = require 'lui.core'

local lib   = core.Timer
local new = lib.new


-- # Constructor


-- Create a new timer without starting it. The interval is specified in seconds.
function lib.new(interval, callback)
  local self = new(interval)
  self.timeout = callback
  return self
end

-- FIXME: documentation

-- Called on double click. This is not called if #click is reimplemented.
-- function lib:doubleClick(x, y, btn, mod)
return lib

