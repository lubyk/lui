--[[------------------------------------------------------

  # Timer

  Native OS timer. This can be used if you do not want to use
  (lens)[http://doc.lubyk.org/lens.html] library and need a simple timer. Timer
  phase and drift depends on OS. Use lens.Timer when possible instead.

  Usage example:
  
    local lui = require 'lui'

    timer = lui.Timer(0.5)

    function timer:timeout()
      -- called when timer fires
    end

    timer:start() -- start now
--]]------------------------------------------------------
local lub  = require 'lub'
local lui  = require 'lui'
local core = require 'lui.core'

local lib   = core.Timer
local new = lib.new


-- # Constructor


-- Create a new timer without starting it. The interval is specified in seconds.
-- The callback can be passed in the constructor or set as `timeout` function.
function lib.new(interval, callback)
  local self = new(interval)
  if callback then
    self.timeout = callback
  end
  return self
end

-- # Methods

-- Start timer with the first "timeout" callback called after `fire_in_seconds`.
-- This method should be used repetitively for irregular timers instead of
-- calling #setInterval multiple times. If `fire_in_seconds` is omited, the
-- timer starts immediately.
-- function lib:start(fire_in_seconds)

-- Stop the timer.
-- function lib:stop()

-- Change timer interval. Use #start instead of changing interval for irregular
-- timers as this method is more costly.
--
-- Interval is specified in seconds.
-- function lib:setInterval(interval)


-- # Callbacks

-- Method called when the timer fires. If you return a number from this
-- method, it will be used as the next interval but it does not alter the
-- regular timeout. Returning a number can be used for irregular timers or to
-- change phase.
-- function lib:timeout()

return lib
