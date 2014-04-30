--[[------------------------------------------------------

  # Application

  GUI main application.

  The class is mainly used to pass scheduling to the OS event loop. It is
  automatically created by the lui library and works along with lub.Scheduler.
  
  Usage example:
  
    local lub = require 'lub'
    local lui = require 'lui'

    -- Implicit creation of lui.Application
    win = lui.Window()

    -- Implicit call to lui.Application.exec
    lub.run()


--]]------------------------------------------------------
local lub  = require 'lub'
local lui  = require 'lui'
local core = require 'lui.core'

local lib  = core.Application
local new  = lib.new
local app

-- # Constructor

-- Create an application (singleton).
function lib.new()
  if not app then
    app = new()
    if coroutine.running() then
      -- Replace poller with lui GUI poller
      -- local poller = lui.Poller()
      -- coroutine.yield('poller', poller)
    end
  end
  return app
end

-- # Runtime

-- Enter the OS graphical interface event loop. This is implicitely called by
-- lub.Scheduler.run when an lui.Application has been created (either explicitely or
-- implicitely by creating an lui.Window ).
-- function lib:exec()

return lib
